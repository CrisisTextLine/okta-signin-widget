<!DOCTYPE html>
<html>

<head>
  <title>Okta Sign-in Widget</title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link href="css/okta-sign-in.css" type="text/css" rel="stylesheet"/>
  <link href="css/okta-theme.css" type="text/css" rel="stylesheet"/>
</head>

<body>
  <div id="okta-login-container"></div>

  <script src="js/okta-sign-in.js"></script>
  <script type="text/javascript">
    function getParameterByName(name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }

    var options = {{{options}}};
    var signIn = new OktaSignIn(options);
    var suppliedExtension = getParameterByName('RelayState') || getParameterByName('relayState');

    signIn.on('authError', function (err) {
      if (err.name=='AuthApiError') {
        console.log(err);
      }
    });

    signIn.renderEl(
      { el: '#okta-login-container' },

      function success(res) {
        // Password recovery flow
        if (res.status === 'FORGOT_PASSWORD_EMAIL_SENT') {
          alert('SUCCESS: Forgot password email sent');
          return;
        }

        // Unlock account flow
        if (res.status === 'UNLOCK_ACCOUNT_EMAIL_SENT') {
          alert('SUCCESS: Unlock account email sent');
          return;
        }

        // User has completed authentication (res.status === 'SUCCESS')

        // 1. Widget is not configured for OIDC, and returns a sessionToken
        //    that needs to be exchanged for an okta session
        if (res.session) {
          console.log(res.user);
          const redirectURI = suppliedExtension || '/app/UserHome';
          res.session.setCookieAndRedirect(options.baseUrl + redirectURI);
          return;
        }

        // 2. Widget is configured for OIDC, and returns tokens. This can be
        //    an array of tokens or a single token, depending on the
        //    initial configuration.
        else if (Array.isArray(res)) {
          console.log(res);
          alert('SUCCESS: OIDC with multiple responseTypes. Check console.');
        }
        else {
          console.log(res);
          alert('SUCCESS: OIDC with single responseType. Check Console');
        }
      },

      function error(err) {
        alert('ERROR: ' + err);
      }
    );
  </script>
</body>

</html>
