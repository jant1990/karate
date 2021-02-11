@hook
Feature: Hooks

    Background: hooks
        # Calling every time
        # * def result = call read('classpath:helpers/Dummy.feature')
        # Calling one time
        
        #* def result = callonce read('classpath:helpers/Dummy.feature')
        #* def username = result.username
        
        #after hooks
        # After Feature
        #* configure afterFeature = function(){karate.call('classpath:helpers/Dummy.feature') }
        # After Scenario
        * configure afterScenario = function(){karate.call('classpath:helpers/Dummy.feature') }
        # custom javascript
        * configure afterScenario = 
        """
            function(){
                karate.log('After Feature/Scenario Text')
            }
        """

    Scenario: First Scenario
        * print username
        * print 'This is the first scenario'

    
    Scenario: Second Scenario
        * print username
        * print 'This is second scenario'