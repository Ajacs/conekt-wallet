# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

#We create users
#
#
user1 = User.create(
{
    name: 'Test1',
    lastname: 'Test1',
    email: 'test1@mail.com',
    password: 'test1',
    password_confirmation: 'test1'
}).tap(&:save)

user2 = User.create(
    {
        name: 'Test2',
        lastname: 'Test2',
        email: 'test2@mail.com',
        password: 'test2',
        password_confirmation: 'test2'
    }).tap(&:save)

root = User.create(
    {
        name: 'Root',
        lastname: 'Root',
        email: 'supersecreataccount@gmail.com',
        password: 'secretpassword',
        password_confirmation: 'secretpassword'
    }).tap(&:save)


#We create account for the users

Account.create({
                   user_id: user1[:id],
                   account_type: 'USER',
                   account_number: Faker::Number.unique.number(10).to_s,
                   balance: 5000.0,
                   available: true
               }).save!

Account.create({
                   user_id: user2[:id],
                   account_type: 'USER',
                   account_number: Faker::Number.unique.number(10).to_s,
                   balance: 0.0,
                   available: true
               }).save!

Account.create({
                   user_id: root[:id],
                   account_type: 'GENERAL',
                   account_number: Faker::Number.unique.number(10).to_s,
                   balance: 0.0,
                   available: true
               }).save!