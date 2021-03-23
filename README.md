# MeetingZero API

This is the API that powers the MeetingZero application. Below are setup instructions to run this locally as well as information on running this on a server for production.

## General Rails Setup

In order to run this application you need to have Ruby and Ruby on Rails installed. Currently this application supports Ruby 2.7.1, and it is recommended to use a Ruby version manager such as [RVM](http://rvm.io/) to switch between versions.

Let's start with the basic gem installation command:

```
bundle install
```

## Database

MeetingZero is configured to use PostgreSQL for its database. You will need a recent version of PostgreSQL running and you will also need to run the migrations to build the database schema:

```
rails db:migrate
```

## Websockets

MeetingZero uses websockets for the realtime communications throughout the workshops. Websockets are handled through a tool called [AnyCable](https://anycable.io/), which handles websocket requests through a Go server that connects via gRPC to the Rails application.

For setup, please refer to the [AnyCable documentation](https://anycable.io/).

## Hivemind

Since you will need the Rails server, AnyCable gRPC server, and the AnyCable Go server running simultaneously to run MeetingZero locally, it is recommended to use a local process manager. Hivemind will allow you to run these processes simultaneously without requiring you to manually start each process every time.

We have already created the Procfile.dev that you will need in order to run Hivemind with the appropriate processes:

```
hivemind ./Procfile.dev
```

## God

Production deployments will also require the above processes to run as well. When in production it is important to monitor daemonized processes as well as restart them if they fail. [God](http://godrb.com/) is a Ruby process manager that does just that, and we have included configurations to run these processes using God. You can view this configuration file in config/run_processes.god.

The only other process that God will spin up that Hivemind does not is Resque-Pool. Resque-Pool is a tool that creates worker pools for Resque tasks, and is mostly used in MeetingZero for sending emails as delayed jobs.
