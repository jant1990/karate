@jbrotons
Feature: Sign up new user

    Background: Preconditions
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * def timeValidator = read('classpath:helpers/timeValidator.js')

        * def jsFunction = 
        """
            function () {
                var DataGenerator = Java.type('helpers.DataGenerator')
                var generator = new DataGenerator();
                return generator.getRandomUsername2()
            }
        """
        * def randomUsername2 = call jsFunction

        Given url apiUrl
    
    Scenario: New user Sign up
        # Given def userData = {"email": "jbrotons90@gmail.com", "username": "jbrotonsUser12"}

        * def randonEmail = dataGenerator.getRandomEmail()
        * def randomUsername = dataGenerator.getRandomUsername()

        Given path 'users'
        And request 
        """
        {
            "user":{
                 "email":#(randonEmail),
                 "password":"pepitogrillo01",
                 "username": #(randomUsername2)
            }
        }        
        """
        When method Post
        Then status 200
        And match response ==
        """
            {
                "user": {
                    "id": "#number",
                    "email": "#(randonEmail)",
                    "createdAt": "#? timeValidator(_)",
                    "updatedAt": "#? timeValidator(_)",
                    "username": "#(randomUsername2)",
                    "bio": null,
                    "image": null,
                    "token": "#string"
                }
            }
        """