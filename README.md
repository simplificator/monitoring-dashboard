# Monitoring Dashboard

## Description

This application is a monitoring dashboard that allows you to display your tests and your CI. It supports the following API's:

1. Semaphore
2. New Relic
3. Nodeping
4. Github
5. Moco

The application consists of an umbrella application that contains two sub-applications:

1. A HTTP-Server application that can receive pushes from the API's that provide push notifications.

2. A frontend application that uses the [Kitto framework](https://github.com/kittoframework/kitto)

## Installation

* ``mix deps.get && npm install``
* ``brew install yarn``

## Configuration

* Make sure you set your api keys as environment variables in your shell script
* Make sure you run both sub-applications on different ports

## Start the Application

* In the umbrella application directory, start your server: ``mix server``
* In the same directory, start yarn: `yarn run start``
