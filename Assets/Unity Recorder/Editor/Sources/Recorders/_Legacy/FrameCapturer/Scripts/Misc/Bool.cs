using System;
using UnityEngine;

namespace UnityEditor.Recorder.FrameCapturer
{
    // bool is marshal as int (4 byte) by default and you need ugly [MarshalAs(UnmanagedType.U1)] to pass to (or receive from) C++ code.
    // this struct emulates bool and marshal as byte (1 byte). this makes things bit easier in some cases.
    [Serializable]
    struct Bool
    {
        [SerializeField] byte v;
        public static implicit operator bool(Bool v) { return v.v != 0; }
        public static implicit operator Bool(bool v) { Bool r; r.v = v ? (byte)1 : (byte)0; return r; }

        public static Bool True { get { Bool r; r.v = 1; return r; } }
    }
}