using UnityEngine;

namespace Demoscene
{
    public class CursorHider : MonoBehaviour
    {

#if !UNITY_EDITOR
        void Start()
        {
            Cursor.visible = false;
        }
#endif

    }
}
