<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="urn:iso:std:iso:20022:tech:xsd:pain.002.001.02"
                xmlns:ax="http://schemas.microsoft.com/dynamics/2011/01/documents/Message"
                xmlns="http://schemas.microsoft.com/dynamics/2011/01/documents/Message"
                xmlns:userCSharp="http://schemas.microsoft.com/BizTalk/2003/userCSharp"
                xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="xsl doc ax">
	<xsl:output method="xml" encoding="utf-8" indent="no" />
	<xsl:namespace-alias stylesheet-prefix="ax" result-prefix="#default" />
	<xsl:template match="/">
		<ax:Envelope>
			<ax:Header>
				<MessageId>
					 <xsl:value-of select="userCSharp:getMessageId()"/> 					
				</MessageId>
				<ax:Action>http://schemas.microsoft.com/dynamics/2011/01/services/StudentDetailsDemo/update</ax:Action> 
			</ax:Header>
			<Body>
				<MessageParts xmlns="http://schemas.microsoft.com/dynamics/2011/01/documents/Message">					
					<StudentDetailsDemo xmlns="http://schemas.microsoft.com/dynamics/2008/01/documents/StudentDetailsDemo">
            <StudentDetails class="entity" action="update">
							<_DocumentHash></_DocumentHash>
							<RecId>
								<xsl:value-of select="substring(doc:OrgnlEndToEndId,1,10)" />
							</RecId>
							<RecVersion></RecVersion>
							<CurrencyCode></CurrencyCode>
							<PaymentStatus>
								<xsl:variable name="var:ACK1Status" select="doc:Document/doc:pain.002.001.02/doc:OrgnlGrpInfAndSts/doc:GrpSts" />
								<xsl:value-of select="concat($var:ACK1Status,'ACK1')"/>
							</PaymentStatus>
							<SONExchangeRateType></SONExchangeRateType>
						</StudentDetails>						
					</StudentDetailsDemo>
				</MessageParts>
			</Body>
		</ax:Envelope>
	</xsl:template>
	<msxsl:script language="C#" implements-prefix="userCSharp">
		<![CDATA[  
		public string str2guid(String _guid)
		{  
			Guid guid = new Guid(_guid);  
			return guid.ToString();
		} 
		public string getMessageId()
		{
		  string s = Guid.NewGuid().ToString();
		  return s;
		}
		
		]]>
	</msxsl:script>
</xsl:stylesheet>