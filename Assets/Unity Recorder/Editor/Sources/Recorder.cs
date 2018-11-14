using System;
using System.Collections.Generic;
using UnityEngine;

namespace UnityEditor.Recorder
{
    enum ERecordingSessionStage
    {
        BeginRecording,
        NewFrameStarting,
        NewFrameReady,
        FrameDone,
        EndRecording,
        SessionCreated
    }

    abstract class Recorder : ScriptableObject
    {
        static int sm_CaptureFrameRateCount;
        bool m_ModifiedCaptureFR;

        public int recordedFramesCount { get; set; }
        
        protected List<RecorderInput> m_Inputs;

        public virtual void Awake()
        {
            sm_CaptureFrameRateCount = 0;
        }

        public virtual void Reset()
        {
            recordedFramesCount = 0;
            recording = false;
        }

        protected virtual void OnDestroy()
        {
            if (m_ModifiedCaptureFR )
            {
                sm_CaptureFrameRateCount--;
                if (sm_CaptureFrameRateCount == 0)
                {
                    Time.captureFramerate = 0;
                    if (Options.verboseMode)
                        Debug.Log("Recorder resetting 'CaptureFrameRate' to zero");
                }
            }
        }

        public abstract RecorderSettings settings { get; set; }

        public virtual void SessionCreated(RecordingSession session)
        {
            if (Options.verboseMode)
                Debug.Log(string.Format("Recorder {0} session created", GetType().Name));

            settings.SelfAdjustSettings(); // ignore return value.

            var fixedRate = settings.frameRatePlayback == FrameRatePlayback.Constant ? (int)settings.frameRate : 0;
            if (fixedRate > 0)
            {
                if (Time.captureFramerate != 0 && fixedRate != Time.captureFramerate )
                    Debug.LogError(string.Format("Recorder {0} is set to record at a fixed rate and another component has already set a conflicting value for [Time.captureFramerate], new value being applied : {1}!", GetType().Name, fixedRate));
                else if( Time.captureFramerate == 0 && Options.verboseMode )
                    Debug.Log("Frame recorder set fixed frame rate to " + fixedRate);

                Time.captureFramerate = fixedRate;

                sm_CaptureFrameRateCount++;
                m_ModifiedCaptureFR = true;
            }

            m_Inputs = new List<RecorderInput>();
            foreach (var inputSettings in settings.inputsSettings)
            {               
                var input = (RecorderInput)Activator.CreateInstance(inputSettings.inputType);
                input.settings = inputSettings;
                m_Inputs.Add(input);
                SignalInputsOfStage(ERecordingSessionStage.SessionCreated, session);
            }
        }

        public virtual bool BeginRecording(RecordingSession session)
        {
            if (recording)
                throw new Exception("Already recording!");

            if (Options.verboseMode)
                Debug.Log(string.Format("Recorder {0} starting to record", GetType().Name));
         
            return recording = true;
        }

        public virtual void EndRecording(RecordingSession session)
        {
            if (!recording)
                return;
            
            recording = false;

            if (m_ModifiedCaptureFR )
            {
                m_ModifiedCaptureFR = false;
                sm_CaptureFrameRateCount--;
                if (sm_CaptureFrameRateCount == 0)
                {
                    Time.captureFramerate = 0;
                    if (Options.verboseMode)
                        Debug.Log("Recorder resetting 'CaptureFrameRate' to zero");
                }
            }

            foreach (var input in m_Inputs)
            {
                if (input != null)
                    input.Dispose();
            }

            if(Options.verboseMode)
                Debug.Log(string.Format("{0} recording stopped, total frame count: {1}", GetType().Name, recordedFramesCount));

            ++settings.take;
        }
        
        public abstract void RecordFrame(RecordingSession ctx);
        
        public virtual void PrepareNewFrame(RecordingSession ctx)
        {
        }

        public virtual bool SkipFrame(RecordingSession ctx)
        {
            return !recording 
                || (ctx.frameIndex % settings.captureEveryNthFrame) != 0 
                || ( settings.recordMode == RecordMode.TimeInterval && ctx.currentFrameStartTS < settings.startTime )
                || ( settings.recordMode == RecordMode.FrameInterval && ctx.frameIndex < settings.startFrame )
                || ( settings.recordMode == RecordMode.SingleFrame && ctx.frameIndex < settings.startFrame );
        }

        public bool recording { get; protected set; }

        public void SignalInputsOfStage(ERecordingSessionStage stage, RecordingSession session)
        {
            if (m_Inputs == null)
                return;

            switch (stage)
            {
                case ERecordingSessionStage.SessionCreated:
                    foreach( var input in m_Inputs )
                        input.SessionCreated(session);
                    break;
                case ERecordingSessionStage.BeginRecording:
                    foreach( var input in m_Inputs )
                        input.BeginRecording(session);
                    break;
                case ERecordingSessionStage.NewFrameStarting:
                    foreach( var input in m_Inputs )
                        input.NewFrameStarting(session);
                    break;
                case ERecordingSessionStage.NewFrameReady:
                    foreach( var input in m_Inputs )
                        input.NewFrameReady(session);
                    break;
                case ERecordingSessionStage.FrameDone:
                    foreach( var input in m_Inputs )
                        input.FrameDone(session);
                    break;
                case ERecordingSessionStage.EndRecording:
                    foreach( var input in m_Inputs )
                        input.EndRecording(session);
                    break;
                default:
                    throw new ArgumentOutOfRangeException("stage", stage, null);
            }
        }
    }
}
