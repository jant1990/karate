@debug
Feature: Tests for the home page

    Background: Define URL
         Given url apiUrl

    Scenario: Get all tags
        Given path 'tags'
        When method Get 
        Then status 200
        And match response.tags contains ['HITLER', 'SIDA']
        And match response.tags !contains 'truck'
        And match response.tags contains any ['fish','test','Gandhi']
        # And match response.tags contains only ['test']
        And match response.tags == "#array"
        And match each response.tags == "#string"


    Scenario: Get 10 articles from the page
        Given params {limit: 10, offset: 0}
        Given path 'articles'
        When method Get
        Then status 200
        And match response.articles == '#[10]'
        And match response.articlesCount == 500
        And match response.articlesCount != 100
        And match response == {"articles": "#array", "articlesCount": 500}
        And match response.articles[0].createdAt contains '2021'
        And match response.articles[*].favoritesCount contains 1
        # And match response.articles[*].author.bio contains null
        And match response..bio contains null
        And match each response..following == false

