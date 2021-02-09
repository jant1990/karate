@regression
Feature: Articles

    Background: Define URL
        Given url apiUrl
        # Given path 'users/login'
        # And request {"user":{"email":"jbrotons@outlook.com","password":"pepitogrillo01"}}
        # When method Post 
        # Then status 200
        # * def token = response.user.token
        # * def tokenResponse = call read('classpath:helpers/CreateToken.feature')
        # * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature')
        # * def token = tokenResponse.authToken

    Scenario: Create a new article
        #Given header Authorization = 'Token ' + token
        Given path 'articles'
        And request {"article":{"tagList":["jant901"],"title":"jant901","description":"jant901","body":"jant901"}}
        When method Post
        Then status 200
        And match response.article.title == 'jant901'
        

    Scenario: Delete article
        #Given header Authorization = 'Token ' + token
        Given path 'articles'
        And request {"article":{"tagList":["jant902"],"title":"jant902","description":"jant902","body":"jant902"}}
        When method Post
        Then status 200
        And match response.article.title == 'jant902'
        * def articleId = response.article.slug

        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].title == 'jant902'

        #Given header Authorization = 'Token ' + token
        Given path 'articles', articleId 
        When method Delete
        Then status 200

        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].title != 'jant902'
