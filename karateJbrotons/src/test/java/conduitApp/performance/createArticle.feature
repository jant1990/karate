@parallel=false
Feature: Articles

    Background: Define URL
        Given url apiUrl
        * def articleRequestBody = read('classpath:conduitApp/json/newArticleRequest.json')
        * def dataGenerator = Java.type('helpers.DataGenerator')
        # all session gatling with __gatling
        * set articleRequestBody.article.title = __gatling.Title
        * set articleRequestBody.article.description = __gatling.Description
        * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body
        * print articleRequestBody

        * def sleep = function(ms){ java.lang.Thread.sleep(ms) }
        * def pause = karate.get('__gatling.pause', sleep)


    Scenario: Create and delete new article
        Given path 'articles'
        And request articleRequestBody
        When method Post
        Then status 200
        * def articleId = response.article.slug

        # User think time
        #* pause(5000)
    
        #Given path 'articles', articleId 
        #When method Delete
        #Then status 200