<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var"
        exclude-result-prefixes="msxsl var s0 s1 userCSharp" version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="urn:iso:std:iso:20022:tech:xsd:pain.001.001.02" xsi:schemaLocation="urn:iso:std:iso:20022:tech:xsd:pain.001.001.02 l:\ecsqa\XML200~2\XMLORI~1\pain.001.001.02.xsd"
        xmlns:s0="http://schemas.microsoft.com/dynamics/2008/01/sharedtypes"
        xmlns:s1="http://schemas.microsoft.com/dynamics/2008/01/documents/StudentDetails"
        xmlns:userCSharp="http://schemas.microsoft.com/BizTalk/2003/userCSharp" >

  <xsl:template match="/">
    <xsl:apply-templates select="/s1:StudentDetails" />
  </xsl:template>
  <xsl:template match="/s1:StudentDetails">
    <Document>
      <pain.001.001.02>
        <GrpHdr>
              <xsl:variable name="var:v1" select="userCSharp:DateCurrentDateTime()" />
              <MsgId>
                <xsl:value-of select="userCSharp:getMessageId()"/>
              </MsgId>
              <CreDtTm>
                <xsl:value-of select="$var:v1" />
              </CreDtTm>
        </GrpHdr>

        <StudentDetails>
          <xsl:for-each select="s1:StudentDetails">
            <Student>
              <StudentId>
                <xsl:value-of select="s1:USNNo/text()" />
              </StudentId>
              <StudentName>
                <xsl:value-of select="s1:StudentName/text()" />
              </StudentName>
              <Department>
                <xsl:value-of select="s1:Dept/text()" />
              </Department>
              <School>Xaviers</School>
            </Student>
          </xsl:for-each>
         </StudentDetails>   
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

      public string getMessageId()
      {
        string s = Guid.NewGuid().ToString("N");
        return s;
      }

    ]]>
  </msxsl:script>
</xsl:stylesheet>