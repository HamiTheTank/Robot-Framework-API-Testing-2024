*** Settings ***
Resource    ${CURDIR}/../resources/common.robot


*** Test Cases ***
TC_002_Validate_Post_Request

    [Documentation]    Create a new student
    [Tags]    api
    [Setup]    test setup
    [Teardown]    test teardown
    [Timeout]    15 seconds

    ${body}=    Load Json From File    ${CURDIR}/../resources/TC_002_Test_Data.json
    ${response}=    POST On Session  current_session  /api/studentsDetails  json=${body}  headers=&{content_type_json}
    Should Be Equal As Integers    ${response.status_code}    201
    ${json}=  Convert String To Json    ${response.content}
    ${first_name}=    Get Value From Json    ${json}    $..first_name  fail_on_empty=${True}
    Should Be Equal As Strings    ${first_name[0]}    FirstName