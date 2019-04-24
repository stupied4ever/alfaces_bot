Alface's Bot
============

This project is being mainted as a personal reminder/calendar. The current
version was developed during 3 days on a sprint, so it's not as good as it
should.

## Features

This bot helps you to remember all you need to do. The allowed commends are:

### Remember me to do something in x minutes, hours, days:

/todo 5m task
/todo 1h task
/todo 1d task

### Remember me to do something in d/m H:M format:

/todo 13/01 16:20 task

### Remember me to do something I dont know when:

/todo task

### Show me all the tasks I have to do

/todo (list all tasks)

## Environment variables

This project uses few envs, the development version of them are on
available inside an encrypted file named `.env.development.gpg`.
This needs to be encrypted because of sensible variables, such as
`TELEGRAM_TOKEN`.

If you need access, please read this [blackbox-indoctrinate](https://github.com/StackExchange/blackbox#how-to-indoctrinate-a-new-user-into-the-system)
section on it's repo and add your self as admin (you will need our
approvement). Otherwise, if you only needs to understand the variables needed,
it's available on `.env.sample`.

## Running locally

`docker-compose run bot`

Of if you just need a playgrond:

`docker-compose run bot bash`

## Tests

`docker-compose run bot bundle exec rspec`



