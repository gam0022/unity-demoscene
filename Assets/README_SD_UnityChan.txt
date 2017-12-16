README_SD_UnityChan.TXT

『SDユニティちゃん 3Dモデルデータ』Ver 1.01 Unity5 対応モデル

2016/01/29 Unity Technologies Japan

【修正履歴】
Ver. 1.01　2016/01/29　サンプルシーンをUnity5に差し替え＆スクリプトをSDこはくちゃんズのもの（最新版）に差し替え
Ver. 1.00　2014/12/28　最初のリリース（Unity4向け）

【配布ライセンス】
本デジタルアセットデータは「ユニティちゃんライセンス条項（UCL）」（配布時点での最新版は、UCL 2.00）に基づき公開されるデジタルアセットデータです。
最新版の「ユニティちゃんライセンス条項」は以下をご確認ください。

ユニティちゃんライセンス条項・要約
http://unity-chan.com/contents/guideline/

ユニティちゃんライセンス条項・正文
http://unity-chan.com/contents/license_jp/

キャラクター利用のガイドライン（FAQ）
http://unity-chan.com/contents/faq/

特にFAQでは、本ライセンスの元で、クリエイターの皆さんが「できること」「できないこと」を詳しく具体例をあげて説明しています。
使用前に必ずご一読していただけますよう、よろしくお願いします。


【利用環境】
本デジタルアセットデータは、Unity 5.2.3 f1で作成しました。
Unity 5.2.3 f1 以降のUnityで利用することができます。


【使い方】
Unity 5.2.3 f1 以降のUnityで新規プロジェクトを作成し、プロジェクトウィンドウに本 Unitypackage をD&Dします。
正常に解凍され、Assetsフォルダ以下にUnityChanフォルダが新規作成されることをご確認ください。


【サンプルシーン】
\Assets\UnityChan\SD_UnityChan\Scenes　以下に、各モデルごとにサンプルシーンがあります。

SDユニティちゃん Mecanim/Humanoidサンプルシーン
SD_unitychan_Humanoid.unity

SDユニティちゃん Mecanim/Genericサンプルシーン
SD_unitychan_Generic.unity


【サンプルシーンのキャラクターにアタッチされているコンポーネント】
各シーンには、SDユニティちゃんのキャラクターモデルが必ず１つあります。
キャラクタ－モデルにアタッチされている主なコンポーネントは以下のようになっています。

●Animatorコンポーネント
　Mecanim/Humanoid形式のAnimatorコンポーネントです。
　AnimatorコントローラはMecanim/HumanoidもしくはMecanim/Gerneric毎に異なります。

●Idle Changerコンポーネント
　アニメーションを切り替えるコンポーネントです。

●Face Updateコンポーネント
　フェイスを切り替えるコンポーネントです。

●Auto Blink for SDコンポーネント
　自動目パチ（オートブリンク）をするコンポーネントです。

●Spring Managerコンポーネント
　揺れもの（ダイナミクス）制御をするコンポーネントです。

●Random Windコンポーネント
　モデルが静止している時にも、揺れものを風に吹かれているように揺らすコンポーネントです。
　初期状態は非アクティブです。

●IK Look Atコンポーネント
　Targetを動かすことで、視線を追随されるコンポーネントです。
　初期状態は非アクティブです。
　このコンポーネントは、Mecanim/Humanoid版のSDユニティちゃんにのみアタッチされています。


【お問い合わせ先】
ユニティ・テクノロジーズ・ジャパン合同会社
unity-chan@unity3d.co.jp

