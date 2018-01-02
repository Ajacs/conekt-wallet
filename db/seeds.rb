# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


#We create users
#
#
user1 = User.create(
{
    name: 'Test1',
    lastname: 'Test1',
    email: 'test1@mail.com',
    password_digest: 'test1',
    password_confirmation: 'test1'
}).tap(&:save)

user2 = User.create(
    {
        name: 'Test2',
        lastname: 'Test2',
        email: 'test2@mail.com',
        password_digest: 'test2',
        password_confirmation: 'test2'
    }).tap(&:save)

root = User.create(
    {
        name: 'Root',
        lastname: 'Root',
        email: 'supersecreataccount@gmail.com',
        password_digest: 'secretpassword',
        password_confirmation: 'secretpassword'
    }).tap(&:save)


#We create account for the users

Account.create({
                   user_id: user1[:id],
                   account_type: 'USER',
                   balance: 5000.0,
                   available: true
               }).save!

Account.create({
                   user_id: user2[:id],
                   account_type: 'USER',
                   balance: 0.0,
                   available: true
               }).save!

Account.create({
                   user_id: root[:id],
                   account_type: 'GENERAL',
                   balance: 0.0,
                   available: true
               }).save!