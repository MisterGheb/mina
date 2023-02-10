bootstrap_alert = (type ,message) => {   // type can be 'alert-success' or 'alert-warning' or 'alert-danger'
    var html = '<div class="d-flex alert '+type+' alert-dismissible w-75 align-self-center my-5" role="alert" id = "alert_placeholder">'+message+'</div>'
    $('#alert_placeholder').remove()
    $('body').prepend(html)
} 

var signupButton = $("#signupSubmit")
var loginButton = $("#loginSubmit")
var githubOAuth = $("#github")


loginButton.click((e)=>{
    e.preventDefault();
    $('#alert_placeholder').remove()
    $('#spinnerloader').remove()
    $('body').prepend('<div class="d-flex spinner-border align-self-center my-5" role="status" id="spinnerloader"></div>')
    var formData = $("#loginForm").serializeArray();
    var body = {}
    body.email = formData[0].value
    body.password = formData[1].value

    const req = new XMLHttpRequest();
    req.open("POST", "https://8000-trilogygrou-tufeb2023mi-iplyhdcrdw5.ws.trilogy.devspaces.com/api/v1/auth/login");
    req.setRequestHeader("Content-type", "application/json")
    req.send(JSON.stringify(body));

    req.onload = function(res) {
        var response = JSON.parse(res.currentTarget.responseText)
        if(response.Code=="BadRequestError")
            bootstrap_alert("alert-warning", response.Message)
        else if(response.token!=null)
        bootstrap_alert("alert-success", "User logged in with token: "+response.token)
        $('#spinnerloader').remove()
        $('body').prepend('<div class="d-none spinner-border align-self-center my-5" role="status" id="spinnerloader"></div>')

        $('#loginForm').get(0).reset()
      }
})

signupButton.click((e)=>{
    e.preventDefault();
    $('#alert_placeholder').remove()
    $('#spinnerloader').remove()
    $('body').prepend('<div class="d-flex spinner-border align-self-center my-5" role="status" id="spinnerloader"></div>')
    var formData = $("#signupForm").serializeArray();

    if(formData[2].value != formData[3].value)
    {
        $("#confirmPassword2").get(0).reportValidity($('#confirmPassword2').get(0).setCustomValidity("Passwords do not match"))
        return
    }

    var body = {}
    body.username = formData[0].value
    body.email = formData[1].value
    body.password = formData[2].value

    const req = new XMLHttpRequest();
    req.open("POST", "https://8000-trilogygrou-tufeb2023mi-iplyhdcrdw5.ws.trilogy.devspaces.com/api/v1/auth/signup/");
    req.setRequestHeader("Content-type", "application/json")
    req.send(JSON.stringify(body));

    req.onload = function(res) {
        var response = JSON.parse(res.currentTarget.responseText)
        if(response.Code=="BadRequestError")
            bootstrap_alert("alert-warning", response.Message)
        else if(response.id!=null)
        bootstrap_alert("alert-success", "User with id: "+response.id+" has been successfully signed up!")
        $('#spinnerloader').remove()
        $('body').prepend('<div class="d-none spinner-border align-self-center my-5" role="status" id="spinnerloader"></div>')

        $('#signupForm').get(0).reset()
      }
})

window.onload=()=>{
    $("#github").attr("href", "https://github.com/login/oauth/authorize?client_id=0be2797b6352a9b5e3d6&redirect_url="+window.location.href)

    const params = new Proxy(new URLSearchParams(window.location.search), {
        get: (searchParams, prop) => searchParams.get(prop),
      });


    if(params.code!=null)
    {

        const req = new XMLHttpRequest();
        req.open("POST", "https://github.com/login/oauth/access_token?client_id=0be2797b6352a9b5e3d6&client_secret=7c34ea895012ef2f292a48fb83f13cff76c5879c&code="+params.code);
        req.setRequestHeader("Accept", "application/json")
        //req.send(JSON.stringify(body));
        req.send()

        req.onload = function(res) {
            var response = JSON.parse(res.currentTarget.responseText)
            if(response.error!=null)
            {
                bootstrap_alert("alert-danger", "Could not Authorize user: "+response.error_description)
                return
            }

                
            const req2 = new XMLHttpRequest();
            req2.open("GET", "https://api.github.com/user");
            req2.setRequestHeader("Authorization", "Bearer "+response.access_token)
            req2.send();

            req2.onload = function(res) {
                var response2 = JSON.parse(res.currentTarget.responseText)
                bootstrap_alert("alert-success", "Github User "+response2.login+" has been successfully authorized and is now logged in!")

                //handle by sending request to chalice app containing response2
            }
        }
    }
}