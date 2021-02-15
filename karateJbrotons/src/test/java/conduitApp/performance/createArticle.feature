@parallel=false
Feature: Articles

    Background: Define URL
        Given url apiUrl
        * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
        * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
        * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body
        * print articleRequestBody


    Scenario: Create and delete new article
        Given path 'articles'
        And request articleRequestBody
        When method Post
        Then status 200
        * def articleId = response.article.slug

    
        Given path 'articles', articleId 
        When method Delete
        Then status 200