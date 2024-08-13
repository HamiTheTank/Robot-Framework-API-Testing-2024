*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    mypythonlibrary.py
Resource    constants.resource


*** Keywords ***
test setup
    Create Session    current_session    ${base_url}

test teardown
    Delete All Sessions
    

print dict items
    [Arguments]    ${dict}
    @{keys}=  Get Dictionary Keys  ${dict}
    FOR  ${key}  IN  @{keys}        
        Log To Console  KEY: ${key}
        ${value}=  Get From Dictionary  ${dict}  ${key}
        Log To Console  VALUE: ${value}
    END

print json items
    [Arguments]    ${json}
    Log To Console  JSON CONTENT:
    Log To Console  ${json}