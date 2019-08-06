REPORT ZTEST_650.

data :
spfli_tab TYPE TABLE OF spfli  ,
 wa_sp like LINE OF SPFLI_TAB ,
 wa_sp2 like LINE OF SPFLI_TAB ,
 tsum TYPE p LENGTH 16 .


select * from spfli  into TABLE SPFLI_TAB .


  LOOP AT SPFLI_TAB INTO WA_SP GROUP BY ( key1 = WA_SP-AIRPFROM  key2 = WA_SP-COUNTRYTO ) .
*    write :/ WA_SP-AIRPFROM .
*    CLEAR tsum .
*   LOOP AT SPFLI_TAB INTO WA_SP2 WHERE AIRPFROM = WA_SP-AIRPFROM .
*      tsum = tsum + WA_SP2-DISTANCE .
*   ENDLOOP.
*   write  : tsum .

    LOOP AT GROUP WA_SP INTO DATA(member) .
        write : / MEMBER-AIRPFROM ,member-COUNTRYTO , member-DISTANCE .

      endloop .
  ENDLOOP.



  DATA: it_messages LIKE sls_msgs OCCURS 0 WITH HEADER LINE.

*START-OF-SELECTION.

CLEAR it_messages.

MOVE '001' TO it_messages-num.

MOVE 'message001' TO it_messages-msg.

APPEND it_messages.

CLEAR it_messages.

MOVE '002' TO it_messages-num.

MOVE 'message002' TO it_messages-msg.

APPEND it_messages.

CLEAR it_messages.

MOVE '003' TO it_messages-num.

MOVE 'message003' TO it_messages-msg.

APPEND it_messages.
CALL FUNCTION 'SLS_MISC_SHOW_MESSAGE_TAB'
  TABLES
    P_MESSAGES                 = it_messages
* EXCEPTIONS
*   NO_MESSAGES_PROVIDED       = 1
*   OTHERS                     = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.



    CALL FUNCTION 'MESSAGES_INITIALIZE'.

    LOOP AT it_return_bapi.
        CALL FUNCTION 'MESSAGE_STORE'
             EXPORTING
                  arbgb                   = it_return_bapi-id
                  exception_if_not_active = ' '
                  msgty                   = it_return_bapi-type
                  msgv1                   = it_return_bapi-message_v1
                  msgv2                   = it_return_bapi-message_v2
                  msgv3                   = it_return_bapi-message_v3
                  msgv4                   = it_return_bapi-message_v4
                  txtnr                   = it_return_bapi-number
                  zeile                   = ' '
             EXCEPTIONS
                  message_type_not_valid  = 1
                  not_active              = 2
                  OTHERS                  = 3.
      ENDLOOP.

    CALL FUNCTION 'MESSAGES_STOP'
           EXCEPTIONS
                a_message = 04
                e_message = 03
                i_message = 02
                w_message = 01.

     IF NOT sy-subrc IS INITIAL.
        CALL FUNCTION 'MESSAGES_SHOW'
             EXPORTING
                  i_use_grid         = 'X'
                  i_amodal_window    = i_amod_window
             EXCEPTIONS
                  inconsistent_range = 1
                  no_messages        = 2
                  OTHERS             = 3.
      ENDIF.