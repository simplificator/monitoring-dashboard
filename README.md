# Monitoring Dashboard

## Description

This application is a monitoring dashboard that allows you to display your tests and your CI. It supports the following API's:

1. Semaphore
2. New Relic
3. Nodeping
4. Github
5. Moco

The monitoring dashboard is an umbrella application that uses the Phoenix framework. It contains two sub-applications:

1. MonitoringDashboard: implements the jobs to poll data from the APIs.

2. MonitoringDashboard.Web: receives push notifications and displays the data in the widgets. The widgets are used from the [Kitto framework](https://github.com/kittoframework/kitto)

## Installation

* ``mix deps.get``
* ``cd apps/monitoring_dashboard_web/assets && yarn install``

## Configuration

* Make sure you set your api keys as environment variables in your shell script

## Start the Application

* In the umbrella application directory, start your server: ``mix phx.server``
