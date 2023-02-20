bootstrap_alert = (type ,message) => {   // type can be 'alert-success' or 'alert-warning' or 'alert-danger'
    var html = '<div class="d-flex alert '+type+' alert-dismissible w-75 align-self-center my-5" role="alert" id = "alert_placeholder">'+message+'</div>'
    $('#alert_placeholder').remove()
    $('body').prepend(html)
} 

var signupButton = $("#signupSubmit")
var loginButton = $("#loginSubmit")
var githubOAuth = $("#github")
var processButton = $('#processSubmit')


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
    req.open("POST", "https://8000-trilogygrou-tufeb2023mi-xr5bncfxvew.ws.trilogy.devspaces.com/api/v1/auth/signup/");
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

processButton.click((e)=>{
    e.preventDefault();
    $('#alert_placeholder').remove()
    $('#spinnerloader').remove() //this is to get the spinner load element and remove it 
    $('body').prepend('<div class="d-flex spinner-border align-self-center my-5" role="status" id="spinnerloader"></div>') //adds HTML to the beggining of body
    var formData = $("#processForm").serializeArray();
    var body = {}

 // Validate input is in correct format
    if(formData[0].value == '')
    {
        $("#S3Links1").get(0).reportValidity($('#S3Links1').get(0).setCustomValidity("this value cannot be empty"))
        $('#spinnerloader').remove()
        return
    }
    if(formData[1].value == '')
    {
        $("#Parallelism1").get(0).reportValidity($('#Parallelism1').get(0).setCustomValidity("this value cannot be empty"))
        $('#spinnerloader').remove()
        return
    }
    if(!Number.isInteger(parseInt(formData[1].value)))
    {
        $("#Parallelism1").get(0).reportValidity($('#Parallelism1').get(0).setCustomValidity("this value must be an integer!"))
        $('#spinnerloader').remove()
        return
    }

    
    body.logFiles = formData[0].value.split(",")
    body.parallelFileProcessingCount = parseInt(formData[1].value)

    const req = new XMLHttpRequest();
    req.open("POST", "https://8000-trilogygrou-tufeb2023mi-xr5bncfxvew.ws.trilogy.devspaces.com/api/v1/process-logs");
    req.setRequestHeader("Content-type", "application/json")
    req.send(JSON.stringify(body));

    req.onload = async function(res) { // reading the data for the upload
        var response = JSON.parse(res.currentTarget.responseText)
        timestamps = response.response

        if(response.response.length==0)
            bootstrap_alert("alert-danger", "S3 Links are Invalid!")
        else
        {
            for(let i=0; i<timestamps.length; i++)
            {
                await upload("timestampscsv/" + timestamps[i].timestamp.replace(/ /g, "").replace(/:/g, "") + ".csv", timestamps[i])
            }
            bootstrap_alert("alert-success", "Success, tables are updating . . .")
            generate_table()
        }
 
        $('#spinnerloader').remove()
        $('body').prepend('<div class="d-none spinner-border align-self-center my-5" role="status" id="spinnerloader"></div>')
        $('#processForm').get(0).reset()
      }
})

async function upload(path, content){ // calling the upload against the presigned URL 
    var body = {}
    body.file_path = path

    const req = new XMLHttpRequest();
    req.open("POST", "https://8000-trilogygrou-tufeb2023mi-xr5bncfxvew.ws.trilogy.devspaces.com/api/v1/upload");
    req.setRequestHeader("Content-type", "application/json")
    req.setRequestHeader("Authorization", "Token ca8cdcc06829dd7845a58c27cce5dda5d444696e")
    req.send(JSON.stringify(body));

    req.onload = async function(res) {
        var response = JSON.parse(res.currentTarget.responseText)
        var url = response.presigned_url.url
        var fields = response.presigned_url.fields

        let rows = [["order_type", "no_of_orders"]]
        for(let j=0; j<content.logs.length; j++)
            rows.push([content.logs[j].order, content.logs[j].count])

        let csvContent = "";
        rows.forEach(rowArray =>  {
            let row = rowArray.join(",");
            csvContent += row + "\r\n";
        });
        const myBlob = new Blob([csvContent], {type : 'text/csv'});

        const formData = new FormData()
        for (let field in fields) {
            if (field === "Content-Type") continue
            formData.append(field, fields[field])
        }
        formData.append("file", myBlob)


        const req2 = new XMLHttpRequest();
        req2.open("POST", url); //posting to the presigned URL
        req2.send(formData);

        append_to_table(content)
    }     
}

generate_table = () => { 

    $('#modal').removeClass('d-flex')
    $('#modal').addClass('d-none')

    if($('#table').length)
        $('#table').remove()

    var html = '<table class="table table d-flex flex-column align-self-center p-5" id="orderTable"><thead><tr><th scope="col" colspan="1">TIMESTAMP</th>'
    +'<th scope="col" colspan="2">ORDER TYPE</th><th scope="col" colspan="3">COUNT</th></tr></thead></table>'
    $('body').append(html)

    html = '<button type="button" class="btn btn-dark" id="backButton">Back</button>'
    $('body').prepend(html)

    $('#backButton').click((e)=>{
        $('#modal').removeClass('d-none')
        $('#modal').addClass('d-flex')
        $('#orderTable').remove()
        $('#backButton').remove()
        $('#alert_placeholder').remove()
    })

}

append_to_table = (content) => { 

    for(let i=0; i<content.logs.length; i++)
    {
        $('#orderTable').append(
            '<tbody>'+
                '<tr>'+
                  '<td colspan="1">'+content.timestamp+'</th>'+
                  '<td colspan="2">'+content.logs[i].order+'</th>'+
                  '<td colspan="3">'+content.logs[i].count+'</th>'+
                '</tr>'+
            '</tbody>'
        )
    }
}