*** Settings ***
Resource    ${CURDIR}/../resources/common.robot


*** Variables ***
${student_ID}              10305526
${expected_first_name}      Angelina


*** Test Cases ***
Get_Student_By_ID
    [Documentation]    Fetch a student by ID and validate its first name
    [Tags]    api-test
    [Setup]    test setup
    [Teardown]    test teardown
    [Timeout]    15 seconds
    

    ${response}=  GET On Session    current_session    api/studentsDetails/${student_ID}
    Should Be Equal As Integers    ${response.status_code}    200
    ${json}=  Convert String To Json    ${response.content}
    ${first_name}=    Get Value From Json    ${json}    $..first_name
    Should Be Equal As Strings    ${first_name[0]}    ${expected_first_name}