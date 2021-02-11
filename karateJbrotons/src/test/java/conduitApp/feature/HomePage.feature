@brotons
Feature: Tests for the home page

    Background: Define URL
         Given url apiUrl

    Scenario: Get all tags
        Given path 'tags'
        When method Get 
        Then status 200
        # And match response.tags contains ['HITLER', 'SIDA']
        # And match response.tags !contains 'truck'
        # And match response.tags contains any ['fish','test','Gandhi']
        # And match response.tags contains only ['test']
        And match response.tags == "#array"
        And match each response.tags == "#string"


    Scenario: Get 10 articles from the page
        * def timeValidator = read('classpath:helpers/timeValidator.js')
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles == '#[10]'
        And match response.articlesCount == 500
        And match response.articlesCount != 100
        And match response == {"articles": "#array", "articlesCount": 500}
        #And match response.articles[0].createdAt contains '2021'
        #And match response.articles[*].favoritesCount contains 1
        # And match response.articles[*].author.bio contains null
        #And match response..bio contains null
        #And match each response..following == false
        #And match each response..following == '#boolean'
        #And match each response..favoritesCount == '#number'
        #And match each response..bio == '##string'
        And match each response.articles ==
        """
            {
                "title": "#string",
                "slug": "#string",
                "body": "#string",
                "createdAt": "#? timeValidator(_)",
                "updatedAt": "#? timeValidator(_)",
                "tagList": '#array',
                "description": "#string",
                "author": {
                    "username": "#string",
                    "bio": "##string",
                    "image": "#string",
                    "following": '#boolean'
                },
                "favorited": '#boolean',
                "favoritesCount": '#number'
            }
        """

    Scenario: Conditional logic
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        * def favoritesCounter = response.articles[0].favoritesCount
        * def article = response.articles[0]
        
        # Conditional
        # * if (favoritesCounter == 0) karate.call('classpath:helpers/addLikes.feature', article)

        # Javascript conditional calling feature
        * def result = favoritesCounter == 0 ? karate.call('classpath:helpers/addLikes.feature', article).favoriteCount : favoritesCounter

        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles[0].favoritesCount == result