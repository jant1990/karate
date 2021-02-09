
Feature: Tests for the home page

    Background: Define URL
         Given url apiUrl

@debug    
    Scenario: New user Sign up
        Given def userData = {"email": "jbrotons90@gmail.com", "username": "jbrotonsUser12"}
        Given path 'users'
        And request 
        """
        {
            "user":{
                 "email":#(userData.email),
                 "password":"pepitogrillo01",
                 "username": #(userData.username)
            }
        }        
        """
        When method Post
        Then status 200