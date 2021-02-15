
Feature: work With DB

    Background: connect to db
        * def dbHanlder = Java.type('helpers.DbHanlder')

    
    Scenario: Seed database with a new Job
        * eval dbHandler.addNewJobWithName("QA2")

    Scenario: Get Level Job
        * def level = dbHandler.getMinAndMaxLevelForJob("Publisher")
        * print level.minLvl
        * print level.maxLvl
        And match level.minLvl = '80'
        And match level.maxLvl = '120'

    