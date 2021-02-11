
Feature: Add likes

    Background: 
    * url apiUrl

    Scenario: add likes
        Given path 'articles', slug, 'favorite'
        And request {}
        When method Post
        Then status 200
        * def favoriteCount = response.articles.favoritesCount
        * print favoriteCount
        * def articleId = response.articles[0].slug