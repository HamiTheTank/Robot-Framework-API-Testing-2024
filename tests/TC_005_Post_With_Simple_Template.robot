*** Settings ***
Resource    ${CURDIR}/../resources/common.robot
Documentation    Create a new student with the provided parameters
Test Tags    api
Test Timeout    15 seconds
Suite Setup    test setup
Suite Teardown    test teardown
Test Template    Create New Student

*** Test Cases ***    FIRST_NAME    MIDDLE_NAME    LAST_NAME    DATE_OF_BIRTH
Lower_case              aaa           bbb            cccc         1/2/2000
Upper_Case              AAA           BBB            CCC          1/2/2000
White_Spaces            A A           B B            C C          1/2/2000
Numbers                 A12           B34            C56          1/2/2000
Symbols1                ~!@           +$%            ^&*          ${null}
Symbols2                .,;           =_?            <>/          ${EMPTY}
US_date                 AAA           BBB            CCC          12/31/1999
EU_date                 AAA           BBB            CCC          31.12.1999
Invalid_date            AAA           BBB            CCC          invalid_date


*** Keywords ***
Create New Student
    [Arguments]    ${first_name}    ${middle_name}    ${last_name}    ${date_of_birth}
    ${dict}=  Create Dictionary    first_name=${first_name}    middle_name=${middle_name}    last_name=${last_name}    date_of_birth=${date_of_birth}
    
    ${response}=    POST On Session  current_session  /api/studentsDetails  json=${dict}  headers=&{content_type_json}
    Should Be Equal As Integers    ${response.status_code}    201
    ${response_json}=  Convert String To Json    ${response.content}
    ${response_first_name}=    Get Value From Json    ${response_json}    $..first_name  fail_on_empty=${True}
    Should Be Equal As Strings    ${response_first_name[0]}    ${first_name}