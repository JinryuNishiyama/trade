# Trade

## 概要

Tradeは、コンソールゲームやスマホゲームで他のプレイヤーとモンスターやアイテムの交換をしたり、対戦相手の募集をするための掲示板です。

アイテムを自分の力だけでは手に入れるのが難しい時や、身近に交換相手がいない時、また、ゲームにランダムマッチング機能がない場合などに利用できます。チャット機能を用いて、交換や対戦の相手を見つけることができます。

## 使い方

1. アカウント登録

ユーザー名・メールアドレス・パスワードを入力することで、アカウントを作成することができます。

1. 掲示板を作成

ゲーム名・掲示板の用途・掲示板の説明を入力して掲示板を作成することができます。
利用したい掲示板がすでに存在する場合は、その掲示板を使用できます。

1. チャットを投稿

チャットで交換や対戦などの相手を見つけて、ゲームを楽しんでください！

## 開発環境

Dockerコンテナ内で開発

Rails: 6.1.4.4
Ruby: 3.0.3
MySQL: 8.0

## テスト

RSpecを用いてテスト
リンターとしてRubocopを使用

CircleCIでRSpecとRubocopを自動化

## 本番環境

Herokuにデプロイ
データベースにはJawsDB(MySQL)を使用

ウェブサイトはこちらから→[Trade](https://portfolio-app-trade.herokuapp.com/)

## ポートフォリオ制作について

### 特に力を入れた点

* 環境構築

Docker関連のファイルやCircleCIの設定ファイルを作成するために、インターネットで複数のサイトを調べました。何度もエラーに直面しましたが、粘り強く調べることで解決することができました。

また、RSpec、特にSystemSpec(Capybara)の設定に関して深く調べました。Docker環境ということもあり少し複雑でしたが、エラーの原因を調べて解決し、最終的にはテストが行えるようになりました。

* RSpecテスト

ModelSpec, RequestSpec, SystemSpecをそれぞれ丁寧に記述しました。SystemSpecでは、考えられ得る状況を全てテストすることを心掛けました。

また、同じ内容を複数回記述するのを避けるため、FactoryBotを用いてテストデータを定義する・特定の処理をモジュールに切り出すなどして、テストコードが見やすくなるように努めました。

### 反省点

cssファイルの記述をBootstrapを用いて行えばよかったと思っています。制作し始めた段階ではBootstrapというGemが何に用いるものなのかを調べていませんでした。Railsにデフォルトで入っているGemについては調べておくべきだということを学びました。
