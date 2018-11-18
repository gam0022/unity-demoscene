using UnityEngine;
using UnityEngine.Playables;

namespace Demoscene.TDF2018
{
    public class MengerBoxMixer : DemoMixerBase<MengerBoxBehaviour, MengerBoxComponet>
    {
        float maxWeight;
        float mengerScale;
        Vector3 mengerOffset;
        float mengerFold;
        float mengerTwistZ;

        Vector4 emissionHsv;
        float emissionHueShiftZ;
        float emissionHueShiftXY;
        float emissionHueShiftBeat;

        Color fogColor;
        float fogIntensity;
        float fogPower;

        protected override void PreProcess(Playable playable, FrameData info, MengerBoxComponet component)
        {
            maxWeight = 0;
            mengerScale = 0;
            mengerOffset = Vector3.zero;
            mengerFold = 0;
            mengerTwistZ = 0;

            emissionHsv = Vector4.zero;
            emissionHueShiftZ = 0f;
            emissionHueShiftXY = 0f;
            emissionHueShiftBeat = 0f;

            fogColor = Color.clear;
            fogIntensity = 0f;
            fogPower = 0f;
        }

        protected override void Process(Playable playable, FrameData info, MengerBoxComponet component,
            ScriptPlayable<MengerBoxBehaviour> input, float weight, int inputPort)
        {
            var clip = input.GetBehaviour().Clip;

            if (weight > maxWeight)
            {
                maxWeight = weight;
            }

            mengerScale += clip.mengerScale * weight;
            mengerOffset += clip.mengerOffset * weight;
            mengerFold += clip.mengerFold * weight;
            mengerTwistZ += clip.mengerTwistZ * weight;

            emissionHsv += clip.emissionHsv * weight;
            emissionHueShiftZ += clip.emissionHueShiftZ * weight;
            emissionHueShiftXY += clip.emissionHueShiftXY * weight;
            emissionHueShiftBeat += clip.emissionHueShiftBeat * weight;

            fogColor += clip.fogColor * weight;
            fogIntensity += clip.fogIntensity * weight;
            fogPower += clip.fogPower * weight;
        }

        protected override void PostProcess(Playable playable, FrameData info, MengerBoxComponet component)
        {
            component.ApplyMengerParams(mengerScale, mengerOffset, mengerFold, mengerTwistZ);
            component.ApplyEmissionParams(emissionHsv, emissionHueShiftZ, emissionHueShiftXY, emissionHueShiftBeat);
            component.ApplyFogParams(fogColor, fogIntensity, fogPower);
        }
    }
}
