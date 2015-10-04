<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:globetrotting="http://www.globetrotting.com/schema"
		xmlns:cms="http://www.globetrotting.com/internal/CMS/schema">

<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

<xsl:key name="items-by-state" match="item" use="state"/>
<xsl:key name="items-by-local-viewing-time" match="item" use="concat(state,'_',area,'_',date,'_',time)"/>

<xsl:template match="/">
	<!-- Grouping using the Muenchian Method - First Pass -->
	<!-- In the for-each statement below, we employ an xslt predicate within the xpath location which only selects those item nodes which match the first item element returned by "items-by-state" key which is indexed per state. This key is indexed with the given state at the time of the nodeset processing.  Thus the foreach loop is not called for each item node in the xml, but for as many times as the number of unique state values. The item nodes are sorted by state and passed to the group_by_state function.-->

	<xsl:element name="channel">
		<xsl:attribute name="uid">001-002-001</xsl:attribute>
		<xsl:element name="type">station_display</xsl:element>
		<xsl:element name="name">pbs_national_broadcast_web_airdates</xsl:element>
		<xsl:element name="media_type">tv</xsl:element>
		<xsl:element name="description"/>

		<xsl:element name="cms:expires"><xsl:value-of select="/channel/cms:expires"/></xsl:element>
		<xsl:element name="cms:node-type"><xsl:value-of select="/channel/cms:node-type"/></xsl:element>

		<xsl:apply-templates select="/channel/globetrotting:show"/>

		<xsl:element name="states">
			<xsl:for-each select="/channel/listing/item[generate-id() = generate-id(key('items-by-state', state)[1])]/state">
				<xsl:sort/>
				<xsl:call-template name="group_by_state"/>
			</xsl:for-each>
		</xsl:element>
	</xsl:element>
</xsl:template>

<xsl:template match="globetrotting:show">
	<xsl:element name="globetrotting:show" namespace="http://www.globetrotting.com/schema">
		<xsl:attribute name="type">internal</xsl:attribute>

		<xsl:element name="globetrotting:title" namespace="http://www.globetrotting.com/schema">
			<xsl:value-of select="globetrotting:title"/>
		</xsl:element>

		<xsl:element name="globetrotting:subtitle" namespace="http://www.globetrotting.com/schema">
			<xsl:value-of select="globetrotting:subtitle"/>
		</xsl:element>

		<xsl:element name="globetrotting:author" namespace="http://www.globetrotting.com/schema">
			<xsl:value-of select="globetrotting:author"/>
		</xsl:element>

		<xsl:element name="globetrotting:summary" namespace="http://www.globetrotting.com/schema">
			<xsl:value-of select="globetrotting:summary"/>
		</xsl:element>

		<xsl:element name="globetrotting:category" namespace="http://www.globetrotting.com/schema">
			<xsl:value-of select="globetrotting:category"/>
		</xsl:element>
	</xsl:element>

</xsl:template>

<xsl:template name="group_by_state">

	<xsl:param name="state_param" select="."/>

	<xsl:element name="group">
		<xsl:attribute name="name"><xsl:value-of select="$state_param"/></xsl:attribute>

		<!-- Grouping using the Muenchian Method - Second Pass -->
		<!-- In the for-each statement below, we employ an xslt predicate within the xpath location whih only selects those item nodes which match the ifrst item element returned by the "items-by-local-viewing-time" key which is indexed with multiple keys and with the current "state" value. The resulting nodeset are the unique viewing times that the item is shown given the particular state, area, date, and time. These unique viewing times are sorted by state, area, date, and time and then passed to the group_by_row function -->
	
		<xsl:for-each select="/channel/listing/item[generate-id() = generate-id(key('items-by-local-viewing-time', concat($state_param, '_', area, '_', date, '_', time))[1])]">
			<xsl:sort select="state"/>
			<xsl:sort select="area"/>
			<xsl:sort select="substring-after(substring-after(substring-after(date,'/'),'/')" data-type="number"/><!--year-->
			<xsl:sort select="substring-before(date,'/')" data-type="number"/><!--month-->
			<xsl:sort select="substring-before(substring-after(date,'/'),'/')" data-type="number"/><!--day-->
			<xsl:sort select="substring-before(time,'M')" data-type="number"/><!--am/pm-->
			<xsl:sort select="substring-before(time,':')" data-type="number"/><!--hour-->
			<xsl:sort select="substring-before(substring-after(time,':'),' ')" data-type="number"/><!--min-->
		
			<xsl:call-template name="group_by_row"/>
		</xsl:for-each>
	</xsl:element>
</xsl:template>

<xsl:template name="group_by_row">
	<xsl:element name="item">
		<xsl:element name="area"><xsl:value-of select="area"/></xsl:element>
		<xsl:element name="date"><xsl:value-of select="date"/></xsl:element>
		<xsl:element name="time"><xsl:value-of select="time"/></xsl:element>

		<!-- Retrieve the potential multiple stations that are showing the item at the same time and collapse them -->
		<xsl:for-each select="key('items-by-local-viewing-time', concat(state,'_',area,'_',date,'_',time))">
			<xsl:element name="station">
				<xsl:element name="name"><xsl:value-of select="station/name"/></xsl:element>
				<xsl:element name="link"><xsl:value-of select="station/link"/></xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>
