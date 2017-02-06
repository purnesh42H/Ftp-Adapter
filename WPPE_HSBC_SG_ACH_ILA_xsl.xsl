<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
        exclude-result-prefixes="msxsl var s0 s1 userCSharp" version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.02" xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.001.001.02 l:\ecsqa\XML200~2\XMLORI~1\pain.001.001.02.xsd"
        xmlns:s0="http://schemas.microsoft.com/dynamics/2008/01/sharedtypes"
        xmlns:s1="http://schemas.microsoft.com/dynamics/2008/01/documents/VendPayments"
        xmlns:userCSharp="http://schemas.microsoft.com/BizTalk/2003/userCSharp" >

  <xsl:template match="/">
    <xsl:apply-templates select="/s1:VendPayments" />
  </xsl:template>
  <xsl:template match="/s1:VendPayments">
    <xsl:for-each select="s1:LedgerJournalTrans">
      <xsl:for-each select="s1:PaymProcessingData">
        <xsl:variable name="var:Country_1" select="userCSharp:InitCumulativeConcat(1)" />
        <xsl:if test="s1:Name/text()='Country'">
          <xsl:variable name="var:Country_2" select="userCSharp:AddToCumulativeConcat(1,string(s1:Value/text()),&quot;1000&quot;)" />
        </xsl:if>
      </xsl:for-each>
    </xsl:for-each>
    <Document>
      <xsl:variable name="var:WhiteSp" select="'                                                                                                   '" />
      <xsl:variable name="var:Country_3" select="userCSharp:GetCumulativeConcat(1)" />

      <pain.001.001.02>
        <xsl:variable name="var:AlphaNumeric" select="'0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
        <xsl:variable name="var:InstrId" select="'-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
        <xsl:variable name="var:Numeric" select="'0123456789'" />

        <GrpHdr>
          <xsl:for-each select="s1:LedgerJournalTrans">
            <xsl:if test="position()=1">
              <xsl:variable name="var:v1" select="userCSharp:DateCurrentDateTime()" />
              <xsl:variable name="var:v2" select="count(/s1:VendPayments/s1:LedgerJournalTrans)" />
              <MsgId>
                <xsl:value-of select="userCSharp:getMessageId()"/>
              </MsgId>
              <CreDtTm>
                <xsl:value-of select="$var:v1" />
              </CreDtTm>
              <!--Modified By Kishor: BankAccountTable - Authorization Mode ILEV/AUTH/FSUM/FDET Start -->
                <xsl:for-each select="s1:BankAccountTable">
                  <Authstn>
                    <xsl:value-of select="s1:WPPEHSBC_AuthorizationMode/text()" />
                    <!-- ILEV-->
                  </Authstn>
                </xsl:for-each>
              <!--BankAccountTable End -->
              <NbOfTxs>
                <xsl:value-of select="$var:v2" />
              </NbOfTxs>
              <Grpg>MIXD</Grpg>
              <xsl:for-each select="s1:CompanyInfo">
                <InitgPty>
                  <Id>
                    <OrgId>
                      <!-- BE SEPA file does not contain the BkPtyId Tag -->
                      <xsl:for-each select="../s1:BankAccountTable">
                        <xsl:if test="s1:WPPEHSBCBkPtyID">
                          <BkPtyId>
                            <xsl:value-of select="s1:WPPEHSBCBkPtyID/text()" />
                          </BkPtyId>
                        </xsl:if>
                      </xsl:for-each>
                    </OrgId>
                  </Id>
                </InitgPty>
                <xsl:variable name="var:partyIdName">
                  <xsl:for-each select="../s1:BankAccountTable">
                    <xsl:value-of select="s1:Name/text()"/>
                  </xsl:for-each>
                </xsl:variable>
                <FwdgAgt>
                  <FinInstnId>
                    <PrtryId>
                      <!--<Id>HSBC Connect</Id>-->
                      <Id>
                        <xsl:value-of select="$var:partyIdName" />
                      </Id>
                    </PrtryId>
                  </FinInstnId>
                </FwdgAgt>
              </xsl:for-each>
            </xsl:if>
          </xsl:for-each>
        </GrpHdr>

        <PmtInf>
          <xsl:for-each select="s1:LedgerJournalTrans">
            <xsl:variable name="var:Country_4" select="userCSharp:GetCumulativeConcat(1)" />
            <xsl:variable name="var:VendBank_1" select="userCSharp:InitCumulativeConcat(2)" />
            <xsl:variable name="var:Vend_1" select="userCSharp:InitCumulativeConcat(3)" />
            <xsl:variable name="var:CurAmount_1" select="userCSharp:InitCumulativeConcat(4)" />
            <!--Validate payment journal currency-->
            <xsl:if test="s1:AmountCurDebit">
              <xsl:variable name="var:CurAmount_2" select="userCSharp:AddToCumulativeConcat(4,string(s1:AmountCurDebit/text()),&quot;1000&quot;)" />
            </xsl:if>
            <xsl:if test="s1:AmountCurCredit">
              <xsl:variable name="var:CurAmount_3" select="userCSharp:AddToCumulativeConcat(4,string(s1:AmountCurCredit/text()),&quot;1000&quot;)" />
            </xsl:if>
            <xsl:variable name="var:CurAmount_4" select="userCSharp:GetCumulativeConcat(4)" />
            <!--Get Country region for the vendor bank account-->
            <!--Get Country region for the vendor bank account-->
            <xsl:for-each select="s1:VendBankAccount">
              <xsl:for-each select="s1:LogisticsPostalAddressView">
                <xsl:choose>
                  <xsl:when test="s1:ISOCode">
                    <xsl:variable name="var:VendBank_2" select="userCSharp:AddToCumulativeConcat(2,string(s1:ISOCode/text()),&quot;1000&quot;)" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:variable name="var:VendBank_2" select="userCSharp:AddToCumulativeConcat(2,string(substring(s1:CountryRegionId/text(),1,2)),&quot;1000&quot;)" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:for-each>
            <!--Get Country region for the vendor -->
            <xsl:for-each select="s1:DimAttrLevVal">
              <xsl:for-each select="s1:VendTable">
                <xsl:for-each select="s1:DirPtyNmPriAddr">
                  <xsl:choose>
                    <xsl:when test="s1:ISOCode">
                      <xsl:variable name="var:VendBank_2" select="userCSharp:AddToCumulativeConcat(2,string(s1:ISOCode/text()),&quot;1000&quot;)" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:variable name="var:VendBank_2" select="userCSharp:AddToCumulativeConcat(2,string(substring(s1:CountryRegionId/text(),1,2)),&quot;1000&quot;)" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </xsl:for-each>
            </xsl:for-each>
            <xsl:variable name="var:VendBank_3" select="userCSharp:GetCumulativeConcat(2)" />
            <xsl:variable name="var:Vend_3" select="userCSharp:GetCumulativeConcat(3)" />

            <!-- <xsl:if test="$var:CurAmount_4&gt;50000 and $var:VendBank_3 != 'FR'">
               <xsl:value-of select="userCSharp:throwOutException('Transaction amount is greater than 50 000€ and destination bank is located out of France')" />
             </xsl:if>
             <xsl:if test="$var:CurAmount_4&gt;50000 and $var:VendBank_3 = 'FR' and $var:Vend_3 != 'FR'">
               <xsl:value-of select="userCSharp:throwOutException('Transaction amount is greater than 50 000€ and destination bank is located in France and payment beneficiary is nonresident of France')" />
             </xsl:if> -->
            <!--</xsl:if> End of FR validation-->
            <!--This appear only once per file-->
            <xsl:if test="position() = 1">
              <PmtInfId>
                <!--<xsl:choose>
                  <xsl:when test="s1:Voucher">
                    <xsl:if test="userCSharp:IsAlphanumeric(s1:Voucher)">
                      <xsl:value-of select="userCSharp:throwOutException('Voucher number contains the non-supported character. Acceptable values are 0-9, a-z, A-Z, and -.')" />
                    </xsl:if>

                    --><!--<xsl:value-of select="concat('P',s1:Voucher/text())" />--><!--
                    <xsl:value-of select="s1:Voucher/text()" />

                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="userCSharp:throwOutException('Voucher is not specified.')" />
                  </xsl:otherwise>
                </xsl:choose>-->
                <xsl:value-of select="s1:JournalNum/text()" />
              </PmtInfId>
              <PmtMtd>TRF</PmtMtd>
              <PmtTpInf>
                <ClrChanl>MPNS</ClrChanl>
              </PmtTpInf>
              <xsl:for-each select="s1:PaymProcessingData">
                <xsl:if test="s1:Name/text()='Processing date'">
                  <xsl:variable name="var:v10" select="s1:Value/text()" />
                  <xsl:variable name="curDate" select="userCSharp:DateCurrentDate()" />
                  <xsl:variable name="curDatePlus45" select="userCSharp:DateCurrentDatePlus45()" />
                  <!-- <xsl:if test="userCSharp:compareDates($var:v10,$curDate)">
                   <xsl:value-of select="userCSharp:throwOutException('Date is Invalid.')" />
                 </xsl:if>
                 <ReqdExctnDt>
                   <xsl:value-of select="$curDate" />
                   <xsl:value-of select="$var:v10" />
                 </ReqdExctnDt> -->
                  <xsl:choose>
                    <xsl:when test="userCSharp:compareDates($var:v10,$curDate) and userCSharp:compareDatePlus45($var:v10)">
                      <ReqdExctnDt>
                        <xsl:value-of select="userCSharp:formatProcessingDate($var:v10)" />
                      </ReqdExctnDt>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="userCSharp:throwOutException('Date is Invalid.')" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:if>
              </xsl:for-each>
              <xsl:variable name="var:ctry">
                <xsl:for-each select="s1:CompanyInfo">
                  <xsl:for-each select="s1:DirPartyPosAddr">
                    <xsl:value-of select="s1:CountryRegionId/text()"/>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:variable>
                  <Dbtr>
                    <xsl:for-each select="s1:CompanyInfo">
                      <xsl:for-each select="s1:DirPartyPosAddr">
                        <xsl:if test="../s1:Name">
                          <Nm>
                            <xsl:value-of select="substring(userCSharp:ReplaceSpecialChars(../s1:Name/text()), 1, 70)" />
                          </Nm>
                        </xsl:if>
                        <!-- SEPA file contain the PstlAdr Tag -->
                        <xsl:variable name="var:v11" select="substring(userCSharp:ReplaceSpecialChars(translate(string(s1:Street/text()) , '&#xA;', ' ')), 1, 70)" />
                        <xsl:variable name="var:v11_1" select="substring(userCSharp:ReplaceSpecialChars(translate(concat(s1:ZipCode/text(),' ', s1:City/text()) , '&#xA;', ' ')), 1, 70)" />
                        <xsl:variable name="var:v11_2" select="substring(translate(concat(s1:Street/text(), ' ', s1:ZipCode/text(),' ', s1:City/text()) , '&#xA;', ' '), 1, 70)" />
                        <PstlAdr>
                          <AdrLine>
                            <xsl:value-of select="substring($var:v11,1,35)" />
                          </AdrLine>
                          <AdrLine>
                            <xsl:value-of select="substring($var:v11_1, 1, 35)" />
                          </AdrLine>
                          <xsl:choose>
                            <xsl:when test="s1:ISOCode">
                              <Ctry>
                                <xsl:value-of select="s1:ISOCode/text()" />
                              </Ctry>
                            </xsl:when>
                            <xsl:otherwise>
                              <Ctry>
                                <xsl:value-of select="substring(s1:CountryRegionId/text(),1,2)" />
                              </Ctry>
                            </xsl:otherwise>
                          </xsl:choose>
                        </PstlAdr>
                      </xsl:for-each>
                    </xsl:for-each>                   
                    <Id>
                      <OrgId>
                        <PrtryId>
                          <Id>
                            <!--E01--><!--<xsl:value-of select="substring(translate(s1:EnterpriseNumber/text(), translate(s1:EnterpriseNumber/text(), $var:Numeric, ''), ''),1,10)" /> -->
                            <xsl:for-each select="s1:PaymProcessingData">
                              <xsl:value-of select="s1:Description/text()"/>
                            </xsl:for-each>
                          </Id>
                        </PrtryId>
                      </OrgId>
                    </Id>
                  </Dbtr>
              <xsl:for-each select="s1:BankAccountTable">
                <DbtrAcct>
                  <Id>
                    <xsl:variable name="var:v18" select="s1:AccountNum" />
                    <xsl:choose>
                      <xsl:when test="string-length($var:v18) = 12">
                        <PrtryAcct>
                          <Id>
                            <xsl:value-of select="translate(s1:AccountNum/text(), translate(s1:AccountNum/text(), $var:AlphaNumeric, ''), '')" />
                          </Id>
                        </PrtryAcct>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="userCSharp:throwOutException('HSBC Singapore account number must be a 12-digit number. For an example 141225193001.')" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </Id>
                  <xsl:choose>
                    <xsl:when test="s1:CurrencyCode">
                      <Ccy>
                        <xsl:value-of select="translate(s1:CurrencyCode/text(), translate(s1:CurrencyCode/text(), $var:AlphaNumeric, ''), '')" />
                      </Ccy>
                    </xsl:when>
                  </xsl:choose>
                </DbtrAcct>
                <DbtrAgt>
                  <FinInstnId>
                    <CmbndId>
                      <xsl:choose>
                        <xsl:when test="s1:SWIFTNo">
                          <BIC>
                            <xsl:value-of select="translate(s1:SWIFTNo/text(), translate(s1:SWIFTNo/text(), $var:AlphaNumeric, ''), '')" />
                          </BIC>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="userCSharp:throwOutException('SWIFT Number is not specified for payment bank account.')" />
                        </xsl:otherwise>
                      </xsl:choose>
                      <ClrSysMmbId>
                        <Id>XXXXX7232</Id>
                      </ClrSysMmbId>
                      <!-- Debtr Country -->
                      <PstlAdr>
                        <!--<Ctry>SG</Ctry>-->
                        <Ctry>
                          <xsl:value-of select="substring($var:ctry, 1, 2)"/>
                        </Ctry>
                      </PstlAdr>
                    </CmbndId>
                  </FinInstnId>
                </DbtrAgt>
              </xsl:for-each>
            </xsl:if>
            <CdtTrfTxInf>
              <PmtId>
                <!-- Specific to FI SEPA -->

                <xsl:choose>
                  <xsl:when test="s1:Voucher">
                    <xsl:if test="userCSharp:IsAlphanumeric(s1:Voucher)">
                      <xsl:value-of select="userCSharp:throwOutException('Voucher number contains the non-supported character. Acceptable values are 0-9, a-z, A-Z, and -.')" />
                    </xsl:if>
                    <InstrId>
                      <!--<xsl:value-of select="concat('I',s1:Voucher/text())" />-->
                      <xsl:value-of select="s1:Voucher/text()" />
                    </InstrId>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="userCSharp:throwOutException('Voucher is not specified.')" />
                  </xsl:otherwise>
                </xsl:choose>
                <EndToEndId>
                  <xsl:value-of select="concat(s1:RecId/text(),userCSharp:RandomString(2))" />
                </EndToEndId>
              </PmtId>
              <Amt>
                <InstdAmt>
                  <xsl:attribute name="Ccy">
                    <xsl:value-of select="s1:CurrencyCode/text()" />
                  </xsl:attribute>
                  <xsl:value-of select="$var:CurAmount_4" />
                </InstdAmt>
              </Amt>
              <xsl:for-each select="s1:DimAttrLevVal">
                <xsl:for-each select="s1:VendTable">
                  <!--<ChrgBr>DEBT</ChrgBr>-->
                  <ChrgBr>
                    <xsl:value-of select="s1:WPPEHSBC_BankCharges/text()" />
                  </ChrgBr>
                </xsl:for-each>
              </xsl:for-each>
              <!--Check if vendor bank account is specified-->
              <xsl:choose>
                <xsl:when test="s1:VendBankAccount">
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="userCSharp:throwOutException('Vendor bank account is not specified.')" />
                </xsl:otherwise>
              </xsl:choose>
              <xsl:for-each select="s1:VendBankAccount">
                <CdtrAgt>
                  <FinInstnId>
                    <CmbndId>
                      <xsl:choose>
                        <xsl:when test="s1:SWIFTNo">
                          <BIC>
                            <xsl:value-of select="translate(s1:SWIFTNo/text(), translate(s1:SWIFTNo/text(), $var:AlphaNumeric, ''), '')" />
                          </BIC>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="userCSharp:throwOutException('SWIFT Number is not specified for payment bank account.')" />
                        </xsl:otherwise>
                      </xsl:choose>
                      <ClrSysMmbId>
                        <!--<Id>XXXXX9186</Id>-->
                        <Id>
                          <xsl:value-of select="concat('XXXXX',s1:WPPEBankTable/text())" />
                        </Id>
                      </ClrSysMmbId>

                      <Nm>
                        <xsl:value-of select="s1:Name"/>
                      </Nm>
                      <xsl:for-each select="s1:LogisticsPostalAddressView">
                        <PstlAdr>
                          <xsl:choose>
                            <xsl:when test="s1:ISOCode">
                              <Ctry>
                                <xsl:value-of select="s1:ISOCode/text()" />
                              </Ctry>
                            </xsl:when>
                            <xsl:otherwise>
                              <Ctry>
                                <xsl:value-of select="substring(s1:CountryRegionId/text(),1,2)" />
                              </Ctry>
                            </xsl:otherwise>
                          </xsl:choose>
                        </PstlAdr>
                      </xsl:for-each>
                    </CmbndId>
                  </FinInstnId>
                  <!-- Branch Code -->
                  <BrnchId>
                    <!--<Id>871</Id>-->
                    <Id>
                      <xsl:value-of select="s1:WPPEBranchCode/text()" />
                    </Id>
                  </BrnchId>
                </CdtrAgt>
              </xsl:for-each>
              <xsl:for-each select="s1:DimAttrLevVal">
                <xsl:for-each select="s1:VendTable">
                  <xsl:for-each select="s1:DirPtyNmPriAddr">
                    <Cdtr>
                      <Nm>
                        <xsl:value-of select="substring(userCSharp:ReplaceSpecialChars(s1:Name/text()), 1, 20)" />
                      </Nm>
                      <xsl:variable name="var:v13" select="substring(userCSharp:ReplaceSpecialChars(translate(string(s1:Street/text()) , '&#xA;', ' ')), 1, 70)" />
                      <xsl:variable name="var:v13_1" select="substring(userCSharp:ReplaceSpecialChars(translate(concat(s1:ZipCode/text(),' ', s1:City/text()) , '&#xA;', ' ')), 1, 70)" />
                      <PstlAdr>
                        <AdrLine>
                          <xsl:value-of select="substring($var:v13,1,35)" />
                        </AdrLine>
                        <AdrLine>
                          <xsl:value-of select="substring($var:v13_1, 1, 35)" />
                        </AdrLine>
                        <xsl:choose>
                          <xsl:when test="s1:ISOCode">
                            <Ctry>
                              <xsl:value-of select="s1:ISOCode/text()" />
                            </Ctry>
                          </xsl:when>
                          <xsl:otherwise>
                            <Ctry>
                              <xsl:value-of select="substring(s1:CountryRegionId/text(),1,2)" />
                            </Ctry>
                          </xsl:otherwise>
                        </xsl:choose>
                      </PstlAdr>
                    </Cdtr>
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:for-each>
              <CdtrAcct>
                <xsl:for-each select="s1:VendBankAccount">
                  <Id>
                    <xsl:choose>
                      <xsl:when test="s1:AccountNum">
                        <PrtryAcct>
                          <Id>
                            <xsl:value-of select="translate(s1:AccountNum/text(), translate(s1:AccountNum/text(), $var:AlphaNumeric, ''), '')" />
                          </Id>
                        </PrtryAcct>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="userCSharp:throwOutException('Account Number is not specified for vendor bank account.')" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </Id>
                </xsl:for-each>
                <xsl:choose>
                  <xsl:when test="s1:CurrencyCode">
                    <Ccy>
                      <xsl:value-of select="translate(s1:CurrencyCode/text(), translate(s1:CurrencyCode/text(), $var:AlphaNumeric, ''), '')" />
                    </Ccy>
                  </xsl:when>
                </xsl:choose>
              </CdtrAcct>
              <!-- Added By Kishor-->
              <RltdRmtInf>
                <xsl:for-each select="s1:DimAttrLevVal">
                  <xsl:for-each select="s1:VendTable">
                    <xsl:choose>
                      <!-- For EMAL Start-->
                      <xsl:when test="s1:WPPEHSBC_ACHPPRemittanceAdvice/text() = 'EMAL'">
                        <RmtLctnMtd>
                          <xsl:value-of select="s1:WPPEHSBC_ACHPPRemittanceAdvice/text()"> </xsl:value-of>
                        </RmtLctnMtd>
                          <xsl:for-each select="s1:DirPartyTable">
                            <xsl:for-each select="s1:LogisticsElectronicAddress_EMAL">
                              <RmtLctnElctrncAdr>
                                <xsl:value-of select="s1:Locator/text()">
                                </xsl:value-of>
                              </RmtLctnElctrncAdr>
                            </xsl:for-each>
                          </xsl:for-each>                        
                      </xsl:when>
                      <!-- For EMAL End-->

                      <!-- For FAX Start-->
                      <xsl:when test="s1:WPPEHSBC_ACHPPRemittanceAdvice/text() = 'FAXI'">
                        <RmtLctnMtd>
                          <xsl:value-of select="s1:WPPEHSBC_ACHPPRemittanceAdvice/text()"> </xsl:value-of>
                        </RmtLctnMtd>
                          <xsl:for-each select="s1:DirPartyTable">
                            <xsl:for-each select="s1:LogisticsElectronicAddress_FAX">
                              <RmtLctnElctrncAdr>
                                <xsl:value-of select="s1:Locator/text()">
                                </xsl:value-of>
                              </RmtLctnElctrncAdr>
                            </xsl:for-each>
                          </xsl:for-each>                        
                      </xsl:when>
                      <!-- For FAX End-->

                      <!-- For POST Start -->
                      <xsl:when test="s1:WPPEHSBC_ACHPPRemittanceAdvice/text() = 'POST'">
                        <RmtLctnMtd>
                          <xsl:value-of select="s1:WPPEHSBC_ACHPPRemittanceAdvice/text()"> </xsl:value-of>
                        </RmtLctnMtd>
                          <xsl:for-each select="s1:DirPtyNmPriAddr">
                            <RmtLctnPstlAdr>
                              <Nm>
                                <xsl:value-of select="substring(userCSharp:ReplaceSpecialChars(s1:Name/text()), 1, 20)" />
                              </Nm>
                              <xsl:variable name="var:v14" select="substring(userCSharp:ReplaceSpecialChars(translate(string(s1:Street/text()) , '&#xA;', ' ')), 1, 70)" />
                              <xsl:variable name="var:v14_1" select="substring(userCSharp:ReplaceSpecialChars(translate(concat(s1:ZipCode/text(),' ', s1:City/text()) , '&#xA;', ' ')), 1, 70)" />
                              <Adr>
                                <AdrLine>
                                  <xsl:value-of select="substring($var:v14,1,35)" />
                                </AdrLine>
                                <AdrLine>
                                  <xsl:value-of select="substring($var:v14_1, 1, 35)" />
                                </AdrLine>
                                <AdrLine>
                                  <xsl:for-each select="s1:LogisticsCountryRegion">
                                    <xsl:value-of select="s1:ShortName/text()"> </xsl:value-of>
                                  </xsl:for-each>
                                </AdrLine>
                                <xsl:choose>
                                  <xsl:when test="s1:ISOCode">
                                    <Ctry>
                                      <xsl:value-of select="s1:ISOCode/text()" />
                                    </Ctry>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <Ctry>
                                      <xsl:value-of select="substring(s1:CountryRegionId/text(),1,2)" />
                                    </Ctry>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </Adr>
                            </RmtLctnPstlAdr>
                          </xsl:for-each>                        
                      </xsl:when>
                      <!-- For POST End-->

                    </xsl:choose>
                  </xsl:for-each>
                </xsl:for-each>

              </RltdRmtInf>
            </CdtTrfTxInf>
          </xsl:for-each>
        </PmtInf>
      </pain.001.001.02>
    </Document>
  </xsl:template>
  <msxsl:script language="C#" implements-prefix="userCSharp">
    <![CDATA[
public string DateCurrentDateTime()
{
	DateTime dt = DateTime.Today;
	string curdate = dt.ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture);
	string curtime = dt.ToString("T", System.Globalization.CultureInfo.InvariantCulture);
	string retval = curdate + "T" + curtime;
	retval = System.DateTime.Now.ToString("s");
	return retval;
}

public string DateCurrentDate()
{
	DateTime dt = DateTime.Today;
	string curdate = dt.ToString("MM-dd-yyyy",System.Globalization.CultureInfo.InvariantCulture);
	string retval = curdate;
	return retval;
}

public string RandomString(int size)
{
    StringBuilder builder = new StringBuilder();
    Random random = new Random();
    char ch;
    for (int i = 0; i < size; i++)
    {
        ch = Convert.ToChar(Convert.ToInt32(Math.Floor(26 * random.NextDouble() + 65)));
        builder.Append(ch);
    }
 
    return builder.ToString();
}

public string getMessageId()
{
  string s = Guid.NewGuid().ToString("N");
  return s;
}

public string DateCurrentDatePlus45()
{
	DateTime dt = DateTime.Today;
	dt = dt.AddDays(45);
	string curdate = dt.ToString("MM-dd-yyyy",System.Globalization.CultureInfo.InvariantCulture);
	string retval = curdate;
	return retval;
}

public bool compareDates(String _prcsngDate, String _curDate)
{
  DateTime dt1 = Convert.ToDateTime(_prcsngDate);
  DateTime dt2 = Convert.ToDateTime(_curDate);
    
  if(DateTime.Compare(dt1,dt2) < 0)
    return false;
  else
   return true;
}

public bool compareDatePlus45(String _prcsngDate)
{
  DateTime dt1 = Convert.ToDateTime(_prcsngDate);
  DateTime dt2 = DateTime.Today;
  
  TimeSpan diff = dt1 - dt2;
  if (diff.Days > 45)
    return false;
  else
    return true;  
}

public string formatProcessingDate(String _date)
{
	DateTime dt = Convert.ToDateTime(_date);
	string curdate = dt.ToString("yyyy-MM-dd", System.Globalization.CultureInfo.InvariantCulture);
	string curtime = dt.ToString("T", System.Globalization.CultureInfo.InvariantCulture);
	string retval = curdate;
	return retval;
}

public bool IsAlphanumeric(String str)
{
  if(System.Text.RegularExpressions.Regex.IsMatch(str, "a-zA-Z0-9"))
    return true;
  else
    return false; 
 }

public string InitCumulativeSum(int index)
{
	if (index >= 0)
	{
		if (index >= myCumulativeSumArray.Count)
		{
			int i = myCumulativeSumArray.Count;
			for (; i<=index; i++)
			{
				myCumulativeSumArray.Add("");
			}
		}
		else
		{
			myCumulativeSumArray[index] = "";
		}
	}
	return "";
}

public System.Collections.ArrayList myCumulativeSumArray = new System.Collections.ArrayList();

public string ExtractNumbers(string expr)
{
  return string.Join( null,System.Text.RegularExpressions.Regex.Split( expr, "[^\\d]" ) );
}

public string AddToCumulativeSum(int index, string val, string notused)
{
	if (index < 0 || index >= myCumulativeSumArray.Count)
	{
		return "";
  }
	double d = 0;
	if (IsNumeric(val, ref d))
	{
		if (myCumulativeSumArray[index] == "")
		{
			myCumulativeSumArray[index] = d;
		}
		else
		{
			myCumulativeSumArray[index] = (double)(myCumulativeSumArray[index]) + d;
		}
	}
	return (myCumulativeSumArray[index] is double) ? ((double)myCumulativeSumArray[index]).ToString(System.Globalization.CultureInfo.InvariantCulture) : "";
}

public string GetCumulativeSum(int index)
{
	if (index < 0 || index >= myCumulativeSumArray.Count)
	{
		return "";
	}
	return (myCumulativeSumArray[index] is double) ? ((double)myCumulativeSumArray[index]).ToString(System.Globalization.CultureInfo.InvariantCulture) : "";
}

public string mod97(string str)
{
    StringBuilder returnString = new StringBuilder();
    Int64 checkDigit = 0;
    foreach(char c in str.ToCharArray())
    {
        if (Char.IsLetter(c))
        {
            returnString.Append(((int)c).ToString());
        }
        else
        {
            returnString.Append(c.ToString());
        }
    }            

            
    if (!String.IsNullOrEmpty(returnString.ToString()))
    {
        checkDigit = Convert.ToInt64(returnString.ToString())%97;                
    }
    returnString.Append(checkDigit.ToString());

    return returnString.ToString();
 }            
public string InitCumulativeConcat(int index)
{
	if (index >= 0)
	{
		if (index >= myCumulativeConcatArray.Count)
		{
			int i = myCumulativeConcatArray.Count;
			for (; i<=index; i++)
			{
				myCumulativeConcatArray.Add("");
			}
		}
		else
		{
			myCumulativeConcatArray[index] = "";
		}
	}
	return "";
}

public System.Collections.ArrayList myCumulativeConcatArray = new System.Collections.ArrayList();

public string AddToCumulativeConcat(int index, string val, string notused)
{
	if (index < 0 || index >= myCumulativeConcatArray.Count)
	{
		return "";
	}
	myCumulativeConcatArray[index] = (string)(myCumulativeConcatArray[index]) + val;
	return myCumulativeConcatArray[index].ToString();
}

public string GetCumulativeConcat(int index)
{
	if (index < 0 || index >= myCumulativeConcatArray.Count)
	{
		return "";
	}
	return myCumulativeConcatArray[index].ToString();
}

public string StringConcat(string param0, string param1)
{
   return param0 + param1;
}


public string StringConcat(string param0, string param1, string param2)
{
   return param0 + param1 + param2;
}


public string MathAbs(string val)
{
	string retval = "";
	double d = 0;
	if (IsNumeric(val, ref d))
	{
		double abs = Math.Abs(d);
		retval = abs.ToString(System.Globalization.CultureInfo.InvariantCulture);
	}
	return retval;
}


public bool IsNumeric(string val)
{
	if (val == null)
	{
		return false;
	}
	double d = 0;
	return Double.TryParse(val, System.Globalization.NumberStyles.AllowThousands | System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out d);
}

public bool IsNumeric(string val, ref double d)
{
	if (val == null)
	{
		return false;
	}
	return Double.TryParse(val, System.Globalization.NumberStyles.AllowThousands | System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out d);
}
//We send the Error Text and the Record Type to the AIF Exception Log.
     public string throwOutException(string errorText){
       throw new System.Exception(errorText);
     }
// Replace special characters for DE payment file     
public string ReplaceSpecialChars(string s)
{
    s = s.Replace("Ä", "AE");
    s = s.Replace("Ö", "OE");
    s = s.Replace("Ü", "UE");
    s = s.Replace("ß", "ss");
    s = s.Replace("ä", "ae");
    s = s.Replace("ü", "UE");
    s = s.Replace("ö", "oe");
    s = s.Replace("<","&lt;");
    s = s.Replace(">","&gt;");
    s = s.Replace("&","&amp;");
    s = s.Replace("'","&apos;");
    s = s.Replace("\"", "&quot;");
    
    foreach (char c in s)
    {
        if (!isNormStr(c))
        {
            s = s.Replace(c, ' ');
        }                    
    }
                      
    return s;
  }
  // Returns if the character is normal for DE payment file
  public static bool isNormStr(int tmpChar2ascii)
  {
            
      if (tmpChar2ascii == ' ' || tmpChar2ascii == '?' || tmpChar2ascii == '&' || tmpChar2ascii == ';')    // BLANK and '?' are normal characters
          return true;
      if (tmpChar2ascii >= '(' && tmpChar2ascii <= ')')       // From ''' to ')' are normal characters
          return true;
      if (tmpChar2ascii >= '+' && tmpChar2ascii <= ':')            // From '+' to ':' are normal characters
          return true;
      if (tmpChar2ascii >= 'A' && tmpChar2ascii <= 'Z')     // From 'A' to 'Z' are normal characters
          return true;
      if (tmpChar2ascii >= 'a' && tmpChar2ascii <= 'z')                   // From 'a' to 'z' are normal characters
          return true;
      return false;
  }
]]>
  </msxsl:script>
</xsl:stylesheet>