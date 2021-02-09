function fn() {    
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
	  apiUrl: 'https://conduit.productionready.io/api/'
  }
  if (env == 'dev') {
    config.userEmail = 'jbrotons@outlook.com'
    config.userPassword = 'pepitogrillo01'
  }
  if (env == 'qa') {
    config.userEmail = 'jbrotons1@outlook.com'
    config.userPassword = 'pepito1grillo01'
  }

  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).authToken

  karate.configure('headers', {Authorization: 'Token ' + accessToken})

  return config;
}