*** Settings ***
Resource    ${CURDIR}/../resources/common.robot


*** Test Cases ***
TC_003_Validate_Delete_Request

    [Documentation]    Create a new student then delete it
    [Tags]    api
    [Setup]    test setup
    [Teardown]    test teardown
    [Timeout]    15 seconds
    
    ${body}=    Load Json From File    ${CURDIR}/../resources/TC_003_Test_Data.json

    ${post_response}=    POST On Session  current_session  /api/studentsDetails  json=${body}  headers=&{content_type_json}
    Should Be Equal As Integers    ${post_response.status_code}    201
    ${json}=  Convert String To Json    ${post_response.content}
    ${create_IDs}=    Get Value From Json    ${json}    $..id
    ${create_ID}=    Get Variable Value    ${create_IDs[0]}

    ${get_response}=    GET On Session    current_session    /api/studentsDetails/${create_ID}
    Should Be Equal As Integers    ${get_response.status_code}    200

    ${delete_response}=    DELETE On Session    current_session   /api/studentsDetails/${create_ID}    
    Should Be Equal As Integers    ${delete_response.status_code}    200
    ${delete_response_json}=    Convert String To Json    ${delete_response.content}
    ${delete_status}=    Get Value From Json    ${delete_response_json}    status
    Should Be Equal As Strings    ${delete_status[0]}    true