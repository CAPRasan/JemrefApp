# JemRef


文系（人文・社会科学系）の和文文献の収集・整理に特化した文献管理ツールです。  
 </br>
<img width="500" alt="jemref_img_index" src="https://github.com/user-attachments/assets/bdc55db9-0b2b-42fa-80d3-7fb6157c7e33">   
 </br>
<img width="500" alt="jemref_img_registration" src="https://github.com/user-attachments/assets/bd20d546-1375-40bf-86e9-72dac3c74a27">
</br>
## なぜJemRefをつくろうと思ったのか
JemRefが目指すのは、 **文献を〈忘れない〉、〈見逃さない〉、〈積み残さない〉** ための文献管理ツールです。  
その開発を進める動機は、次の3つです。

1. **文系の和文文献に適した文献管理ツールがほしい**  
既存の文献管理ツールは、ほとんどが英語圏の文献に最適化されています。  
和文文献を重視する研究者にとって、直感的な操作が難しく、書式もフィットしません。  
いきおい、Excelや手書きのメモに頼ることになりますが、文献の見落とし・見忘れ、記録の重複・紛失などのために、貴重な研究時間を無駄にしてしまいます。  

2. **書誌情報を記録するだけでなく、文献の収集をサポートする機能がほしい**  
文献は年々増加し、質も多様化しています。そのフォローは容易ではありません。  
大学研究者の多忙化や、業績を求める圧力の高まりは、その問題をいっそう複雑にしています。  
文献の見逃しや積み残しをなくし、それを適切に評価・整理できるようサポートすることが、研究の質の底上げにつながると考えます。  

3. **プロ・アマを問わず、本格的に研究できる環境を作りたい**  
文系は、民間からの支援を受けづらい分野です。  
そのため文系は「大学こそが研究の場」でしたが、大学の研究環境は年々劣化しています。  
アマチュア研究者も存在しますが、肩書きがないために受ける不利益が少なくありません。  
良質な研究ツールをWeb上で広く提供し、プロ・アマを問わず誰もが本格的な研究に取り組める環境を整えることが、文系研究の存続・発展にとってきわめて重要と考えます。
## 環境構築

### バージョン情報
* Ruby: 3.3.4
* Ruby on Rails: 7.2.1

### JemRefのセットアップ手順
#### (1) JemRefリポジトリのクローン
下記コマンドを実行してください。
~~~
git clone https://github.com/CAPRasan/JemrefApp.git
~~~

#### (2) Gemのインストール
JemRefのディレクトリに移動し、下記コマンドを実行してください。

~~~
bundle install
~~~

#### (3) データベースの設定
データベースを作成・マイグレーションするため、下記コマンドを順に実行してください。
~~~
rails db:create
~~~
~~~
rails db:migrate
~~~

#### (4) ローカルサーバーを起動
下記コマンドを実行してください。
~~~
rails s
~~~

#### (5) Webブラウザを起動
下記URLにアクセスしてください。  
[http://localhost:3000](http://localhost:3000/)

## 機能
### 現在できること

* ユーザー登録・ログイン  
* 書誌情報の登録（著書、雑誌論文、編著論文）  
* 書誌情報の一覧とフリーワード検索  
* 書誌情報の更新・削除

### 今後実装する予定のもの
次の2つのフェーズに分けて開発します。  
（優先度 高: 3、中: 2、低: 1 ） 
#### 1. 文献管理ツールとしての一般的機能の充実
* タグやメモをつけられるようにします。(3)
* 書誌情報の詳細検索ができるようにします。(3)
* 書誌情報をフォルダで管理できるようにします。(3)
* 博士論文、外国語文献、新聞記事などの書誌形態に対応できるようにします。(2)
* 文献PDFや関連URLを、書誌情報と紐づけられるようにします。(2)
* Cinii、国立国会図書館オンラインなどの外部サイトから、書誌情報を取り込めるようにします。(2)
* 検索した書誌情報を、ExcelやPDFといったファイルにまとめて出力できるようにします。(1)
* 検索した書誌情報を、学会や雑誌に応じた書式で出力できるようにします。(1)

#### 2. 文献情報の入手・整理をサポートする新機能の開発
* 未読文献の整理（積読の解消、優先度づけ）に特化したページを開発します。(3)
* 特定の雑誌や著者について、新刊情報をメールなどで通知する機能を開発します。(2)
* ウェブ上の文献情報や、登録された文献情報をもとに、ユーザーに文献をサジェストできるようにします（実装方法は検討中）。(2)
* サジェストされた内容をユーザーが選別し、未読文献リストに入れられるようにします。(1)
* サジェストされた内容を、メールなどで定期的に通知できるようにします。(1)