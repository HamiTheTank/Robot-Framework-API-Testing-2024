*** Settings ***
Resource    ${CURDIR}/../resources/common.robot

*** Variables ***
${reqreS_url}              https://reqres.in/
${guthub_url}              https://api.github.com/
${github_token}            XXX    #obtain token from github-dev settings
${github_invalid_token}    XXX    #use any random string. it should fail


*** Test Cases ***
Login
    Create Session  reqres  ${reqreS_url}
    ${token}=  Login and Get Token
    Log To Console  TOKEN:\n${token}


View Github Repo With Valid Token Authentication
    Create Session  github  ${guthub_url}
    &{header}=  Create Dictionary  Content-Type=application/json  Authorization=Bearer ${github_token}
    ${valid_get_request}=  GET On Session  github  /repos/HamiTheTank/test_framework  headers=&{header}
    Log To Console  ${valid_get_request.content}
    Should Be Equal As Integers    ${valid_get_request.status_code}    200

View Github Repo With Inalid Token Authentication    
    Create Session  github  ${guthub_url}
    ${header}=  Create Dictionary  Content-Type=application/json  Authorization=Bearer ${github_invalid_token}

    TRY
        ${error_msg}=  Run Keyword And Expect Error  STARTS: HTTPError  GET On Session  github  /repos/HamiTheTank/test_framework  headers=&{header}
        Log To Console  \n\nERROR MESSAGE:\n${error_msg}
        Should Start With  ${error_msg}  HTTPError: 401
    EXCEPT
        Fail  msg=Failed to access URL
    END


*** Keywords ***
Login and Get Token
    ${login_json}=  Create Dictionary  email=eve.holt@reqres.in  password=cityslicka
    ${login_response}=  POST On Session  reqres  /api/login  json=${login_json}  headers=&{content_type_json}
    ${token}=  Set Variable  ${null}
    ${response_json}=  Convert String To Json  ${login_response.content}
    @{tokens}=  Get Value From Json  ${response_json}  $..token
    ${token}=  Set Variable  ${tokens[0]}    
    RETURN  ${token}