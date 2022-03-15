# This file should contain all the record creation needed to seed the database with its default
# values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database
# with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  name: "管理者",
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD'],
  admin: true
)

users = User.create!(
  [
    # users[0]
    {
      name: "ゲストユーザー",
      email: "guest@example.com",
      password: "guestuser",
    },
    # users[1]
    {
      name: "ユーザー1",
      email: "user1@example.com",
      password: SecureRandom.urlsafe_base64,
      icon: File.open("#{Rails.root}/app/assets/images/user1_icon.jpg"),
      introduction: "ユーザー1の紹介文です。",
    },
    # users[2]
    {
      name: "ユーザー2",
      email: "user2@example.com",
      password: SecureRandom.urlsafe_base64,
    },
    # users[3]
    {
      name: "別のユーザー",
      email: "another@example.com",
      password: SecureRandom.urlsafe_base64,
    },
  ]
)

games = Game.create!(
  [
    # games[0]
    {
      name: "ゲーム1",
      purpose: "交換",
      description: "ゲーム1の交換掲示板です。",
      user: users[1],
    },
    # games[1]
    {
      name: "ゲーム2",
      purpose: "交換",
      description: "ゲーム2の交換掲示板です。",
      user: users[1],
    },
    # games[2]
    {
      name: "ゲーム3",
      purpose: "交換",
      description: "ゲーム3の交換掲示板です。",
      user: users[1],
    },
    # games[3]
    {
      name: "ホゲホゲモンスター",
      purpose: "交換",
      description: "ホゲホゲモンスターの交換掲示板",
      user: users[2],
    },
    # games[4]
    {
      name: "ホゲホゲモンスター",
      purpose: "対戦",
      description: "ホゲホゲモンスターの対戦掲示板",
      user: users[2],
    },
    # games[5]
    {
      name: "ホゲホゲモンスター",
      purpose: "マルチプレイ募集",
      description: "ホゲホゲモンスターのマルチプレイ募集掲示板",
      user: users[2],
    },
    # games[6]
    {
      name: "ホゲホゲクエスト",
      purpose: "対戦",
      description: "対戦相手募集",
      user: users[3],
    },
    # games[7]
    {
      name: "ホゲホゲドラゴンズ",
      purpose: "マルチプレイ募集",
      description: "マルチプレイ募集します！",
      user: users[3],
    },
  ]
)

Post.create!(
  [
    {
      text: "テスト",
      chat_num: 1,
      game: games[0],
      user: users[1],
    },
    {
      text: "テスト",
      chat_num: 1,
      game: games[2],
      user: users[1],
    },
    {
      text: "テスト",
      chat_num: 2,
      game: games[2],
      user: users[1],
    },
    {
      text: "ホゲチュウ出せる方いますか？こちらホゲゴン出せます。",
      chat_num: 1,
      game: games[3],
      user: users[2],
    },
    {
      text: ">>1\n交換可能です",
      chat_num: 2,
      game: games[3],
      user: users[1],
    },
    {
      text: ">>2\nよろしくお願いします！",
      chat_num: 3,
      game: games[3],
      user: users[2],
    },
    {
      text: ">>3\nありがとうございました",
      chat_num: 4,
      game: games[3],
      user: users[1],
    },
    {
      text: "求　ホゲボール\n出　ホゲの実",
      chat_num: 5,
      game: games[3],
      user: users[3],
    },
    {
      text: ">>5\nホゲの実出せます",
      chat_num: 6,
      game: games[3],
      user: users[1],
    },
    {
      text: ">>6\n交換お願いします！",
      chat_num: 7,
      game: games[3],
      user: users[3],
    },
    {
      text: ">>7\n交換ありがとうございました",
      chat_num: 8,
      game: games[3],
      user: users[1],
    },
    {
      text: "今日19時頃から対戦できる方いますか？",
      chat_num: 1,
      game: games[6],
      user: users[1],
    },
    {
      text: ">>1\nいけます！",
      chat_num: 2,
      game: games[6],
      user: users[2],
    },
    {
      text: ">>2\n部屋番号1111です",
      chat_num: 3,
      game: games[6],
      user: users[1],
    },
    {
      text: ">>3\n対戦ありがとうございました！",
      chat_num: 4,
      game: games[6],
      user: users[2],
    },
    {
      text: ">>4\nありがとうございました",
      chat_num: 5,
      game: games[6],
      user: users[1],
    },
    {
      text: "ホゲダンジョン行ける方いますか？",
      chat_num: 1,
      game: games[7],
      user: users[1],
    },
    {
      text: ">>1\n今から行けます！",
      chat_num: 2,
      game: games[7],
      user: users[3],
    },
    {
      text: ">>2\nありがとうございます、部屋番号1111です",
      chat_num: 3,
      game: games[7],
      user: users[1],
    },
    {
      text: ">>3\nありがとうございました！",
      chat_num: 4,
      game: games[7],
      user: users[3],
    },
  ]
)
