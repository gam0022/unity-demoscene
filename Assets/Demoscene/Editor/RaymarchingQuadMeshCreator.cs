using UnityEditor;
using UnityEngine;

public static class RaymarchingQuadMeshCreator
{
    static readonly string outputPath = "Assets/Demoscene/Resources/Meshes/RaymarchingQuad.mesh";
    private const int expandBounds = 10000;

    [MenuItem("Tools/CreateRaymarchingQuadMesh")]
    static void CreateRaymarchingQuadMesh()
    {
        var mesh = new Mesh
        {
            vertices = new[]
            {
                new Vector3(1f, 1f, 0f),
                new Vector3(-1f, 1f, 0f),
                new Vector3(-1f, -1f, 0f),
                new Vector3(1f, -1f, 0f),
            },
            triangles = new[] {0, 1, 2, 2, 3, 0}
        };
        mesh.RecalculateNormals();
        mesh.RecalculateBounds();

        var bounds = mesh.bounds;
        bounds.Expand(expandBounds);
        mesh.bounds = bounds;

        var oldAsset = AssetDatabase.LoadAssetAtPath<Mesh>(outputPath);
        if (oldAsset)
        {
            // Update Asset
            EditorUtility.CopySerialized(mesh, oldAsset);
            AssetDatabase.SaveAssets();
        }
        else
        {
            // Create Asset
            AssetDatabase.CreateAsset(mesh, outputPath);
            AssetDatabase.Refresh();
        }
    }
}
