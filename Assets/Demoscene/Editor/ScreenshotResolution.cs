#if UNITY_EDITOR

using UnityEngine;
using UnityEditor;
using System;
using System.IO;

namespace Demoscene.Tool
{
    public class ScreenshotResolution : Editor
    {
        static readonly string saveDirectoryPath = Environment.GetFolderPath(Environment.SpecialFolder.MyPictures) +
                                                   "/" + Application.productName + "/ScreenShot";

        static GameObject disableTarget;

        const string menuPath = "Tools/スクリーンショット/";

        [MenuItem(menuPath + "等倍 #%F12")]
        static void DoScreenshotx1()
        {
            CaptureScreenshot(1);
        }

        [MenuItem(menuPath + "2倍")]
        static void DoScreenshotx2()
        {
            CaptureScreenshot(2);
        }

        [MenuItem(menuPath + "4倍")]
        static void DoScreenshotx4()
        {
            CaptureScreenshot(4);
        }

        [MenuItem(menuPath + "8倍")]
        static void DoScreenshotx8()
        {
            CaptureScreenshot(8);
        }


        [MenuItem(menuPath + "保存ディレクトリを開く", false, 1020)]
        static void OpenSaveDirectory()
        {
            OpenFolder();
        }

        /// <summary>
        /// スクリーンショットを倍率指定で撮る
        /// </summary>
        /// <param name="superSize"></param>
        static void CaptureScreenshot(int superSize)
        {
            // 格納パス
            // ディレクトリ作成
            SafeCreateDirectory(saveDirectoryPath);
            // 日付
            var day = DateTime.Now.ToString("yyyyMMddHHmmss");
            // 出力ファイルパス
            var outputFilePath = saveDirectoryPath + "/" + day + "_" + "x" + superSize.ToString() + ".png";

            // 出力指定してキャプチャー実行
            ScreenCapture.CaptureScreenshot(outputFilePath, superSize);

            // GameViewを含めたエディタ全体を再描画（ここでスクリーンショット描画）
            UnityEditorInternal.InternalEditorUtility.RepaintAllViews();

            // 使いやすいように終わったらフォルダを開く
            OpenFolder();
        }

        static void OpenFolder(string filePath = "")
        {
#if UNITY_EDITOR_OSX
// Mac
            System.Diagnostics.Process.Start(saveDirectoryPath);
#elif UNITY_EDITOR_WIN
            // Windows
            if (string.IsNullOrEmpty(filePath))
            {
                System.Diagnostics.Process.Start(saveDirectoryPath);
            }
#endif
        }

        // ディレクトリが存在しない場合に作る
        public static DirectoryInfo SafeCreateDirectory(string path)
        {
            if (Directory.Exists(path))
            {
                return null;
            }
            return Directory.CreateDirectory(path);
        }
    }
}

#endif
