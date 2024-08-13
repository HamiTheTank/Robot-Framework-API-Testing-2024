*** Settings ***
Resource    ${CURDIR}/../resources/common.robot
Library    jsonschema


*** Variables ***
${table_header}    Dessert_ID : Dessert_NAME : Batter_Type  :  Topping_Type  :  Filling_Name


*** Test Cases ***
Print Formatted Json
    ${json}=  Load Json From File  ${CURDIR}/../resources/Complex_Data.json
    ${dessertsArray}=  Get Value From Json    ${json}    $..items.item
    @{desserts}=  Set Variable  @{dessertsArray[0]}
    ${count}=  Get Length  ${desserts}
    Log To Console  COUNT: ${count}
    FOR  ${dessert}  IN  @{desserts}
        Log To Console  \nDESSERT
        Validate Dessert Schema ${dessert}
        Print Dessert ${dessert}
    END

Update JSON
    [Documentation]    rename existing values in the dessert
    ${json}=  Load Json From File  ${CURDIR}/../resources/Complex_Data.json
    @{dessertsArray}=  Get Value From Json    ${json}    $..items.item
    @{desserts}=  Set Variable  @{dessertsArray[0]}
    ${my_dessert}=  Set Variable  ${desserts[0]}
    
    ${new_name}=  Set Variable  CHEESECAKE_69
    ${new_batter_type}=  Set Variable  FANTASTIC

    Log To Console  \n\nORIGINAL JSON:\n${my_dessert}
    ${updated_dessert}=  Update Value To Json  ${my_dessert}  $..name    ${new_name}
    ${updated_dessert}=  Update Value To Json  ${updated_dessert}  $..batters.batter[0].type    ${new_batter_type}
    Log To Console  \n\nUPDATED JSON:\n${updated_dessert}
    Validate Dessert Schema ${updated_dessert}

Add Value to JSON
    [Documentation]    add new topping to existing dessert and validate by schema
    ${json}=  Load Json From File  ${CURDIR}/../resources/Complex_Data.json
    @{dessertsArray}=  Get Value From Json    ${json}    $..items.item
    @{desserts}=  Set Variable  @{dessertsArray[0]}
    ${my_dessert}=  Set Variable  ${desserts[0]}
    ${new_topping}=  Create Dictionary  id=9999  type=MARVELLOUS_TOPPING

    Log To Console  \n\nORIGINAL JSON:\n${my_dessert}
    ${updated_dessert}=  Add Object To Json  ${my_dessert}  $..topping  ${new_topping}
    Log To Console  \n\nUPDATED JSON:\n${updated_dessert}\n\n
    Validate Dessert Schema ${updated_dessert}


Delete Value from JSON
    [Documentation]    remove filling from an existing dessert and validate by schema
    ${json}=  Load Json From File  ${CURDIR}/../resources/Complex_Data.json
    @{dessertsArray}=  Get Value From Json    ${json}    $..items.item
    @{desserts}=  Set Variable  @{dessertsArray[0]}
    ${my_dessert}=  Set Variable  ${desserts[5]}

    Log To Console  \n\nORIGINAL JSON:\n${my_dessert}
    ${updated_dessert}=  Delete Object From Json  ${my_dessert}  $..filling[2]    
    Log To Console  \n\nUPDATED JSON:\n${updated_dessert}\n\n
    Validate Dessert Schema ${updated_dessert}
    


*** Keywords ***
Print Dessert ${dessert}
    
    @{dessertInfo}=  Get Dessert Info As Array ${dessert}
    @{batters}=  Get Batters As Array ${dessert}
    @{toppings}=  Get Toppings As Array ${dessert}
    @{fillings}=  Get Fillings As Arary ${dessert}

    #Log To Console  ${table_header}
    Log To Console  ${dessertInfo}
    #Print Dessert Info ${dessertInfo}
    Log To Console  ================== BATTERS ==========
    #Print Json ${batters}
    Print Batter Types ${batters}
    Log To Console  ================== TOPPINGS ==========
    #Print Json ${toppings}
    Print Topping Types ${toppings}
    Log To Console  ================== FILLINGS ==========
    #Print Json ${fillings}
    Print Filling Names ${fillings}


Get Dessert Info As Array ${dessert}
    @{info}=  Set Variable  ${null}
    ${id}=  Get Value From Json  ${dessert}  id
    ${type}=  Get Value From Json  ${dessert}  type
    ${name}=  Get Value From Json  ${dessert}  name
    ${ppu}=  Get Value From Json  ${dessert}  ppu
    @{info}=  Create List  ${id[0]}  ${type[0]}  ${name[0]}  ${ppu[0]}
    RETURN  @{info}


Get Batters As Array ${dessert}
    @{battersArray}=  Get Value From Json  ${dessert}  $..batters.batter    

    ${isEmpty}=  Run Keyword And Return Status    Should Be Empty    ${battersArray}
    IF  ${isEmpty} == ${True}  Return From Keyword

    @{batters}=  Set Variable  ${battersArray[0]}

    ${isEmpty}=  Run Keyword And Return Status    Should Be Empty    ${batters}
    IF  ${isEmpty} == ${True}  Return From Keyword

    RETURN  @{batters}


Get Toppings As Array ${dessert}
    @{toppingsArray}=  Get Value From Json  ${dessert}  $..topping    

    ${isEmpty}=  Run Keyword And Return Status    Should Be Empty    ${toppingsArray}
    IF  ${isEmpty} == ${True}  Return From Keyword

    @{toppings}=  Set Variable  @{toppingsArray[0]}

    ${isEmpty}=  Run Keyword And Return Status    Should Be Empty    ${toppings}
    IF  ${isEmpty} == ${True}  Return From Keyword

    RETURN  @{toppings}


Get Fillings As Arary ${dessert}
    @{fillingsArray}=  Get Value From Json  ${dessert}  $..fillings.filling

    ${isEmpty}=  Run Keyword And Return Status    Should Be Empty    ${fillingsArray}
    IF  ${isEmpty} == ${True}  RETURN  ${null}

    @{fillings}=  Set Variable  @{fillingsArray[0]}

    ${isEmpty}=  Run Keyword And Return Status    Should Be Empty    ${fillings}
    IF  ${isEmpty} == ${True}  RETURN  ${null}

    RETURN  @{fillings}

Print Json ${json}
    FOR  ${item}  IN  @{json}
        Log To Console  ${item}
    END


Print Dessert Info ${dessert_info}
    FOR  ${item}  IN  @{dessert_info}
        Log To Console  ${item}
    END

Print Batter Types ${batters}    
    ${isEmpty}=  Run Keyword And Return Status    Should Be Empty    ${batters}
    IF  ${isEmpty} == ${True}  RETURN  ${null}

    FOR  ${batter}  IN  @{batters}
        ${type}=  Get Value From Json  ${batter}    type
        Log To Console  ${type[0]}
    END


Print Topping Types ${toppings}    
    ${isEmpty}=  Run Keyword And Return Status    Should Be Empty    ${toppings}
    IF  ${isEmpty} == ${True}  RETURN  ${null}

    FOR  ${topping}  IN  @{toppings}
        ${type}=  Get Value From Json  ${topping}    type
        Log To Console  ${type[0]}
    END
    
Print Filling Names ${fillings}    
    ${isEmpty}=  Run Keyword And Return Status    Should Be Empty    ${fillings}
    IF  ${isEmpty} == ${True}  RETURN  ${null}

    FOR  ${filling}  IN  @{fillings}
        ${type}=  Get Value From Json  ${filling}    name
        Log To Console  ${type[0]}
    END

Validate Dessert Schema ${dessert}
    Validate Json By Schema File    json_object=${dessert}    path_to_schema=${CURDIR}/../resources/dessert_schema.json

Validate Batter Schema ${json}
    Validate Json By Schema File    json_object=${json}    path_to_schema=${CURDIR}/../resources/batter_schema.json

Validate Topping Schema ${json}
    Validate Json By Schema File    json_object=${json}    path_to_schema=${CURDIR}/../resources/topping_schema.json

Validate Filling Schema ${json}
    Validate Json By Schema File    json_object=${json}    path_to_schema=${CURDIR}/../resources/filling_schema.json