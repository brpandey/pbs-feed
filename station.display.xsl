<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:globetrotting="http://www.globetrotting.com/schema">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:output doctype-system="http://www.w3.org/TR/xhtml1/xhtml1-transitional.dtd"/>
	<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"/>

	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="channel/globetrotting:show/globetrotting:title"/>: Station Support</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<meta content="Stress-free tours with great guides, small groups, big comfy buses, and no groups." name="Description" />
				<meta content="Bus tours, guided tours" name="Keywords" />
				<link href="nav.css" rel="stylesheet" type="text/css"/>
				<link href="menu.css" rel="stylesheet" type="text/css"/>
				<link href="jordanProgram.css" rel="stylesheet" type="text/css"/>
			</head>
			<body>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr id="header">
						<td width="50%" nowrap="nowrap">
							<a href="http://www.globetrotting.com">
								<img src="http://www.globetrotting.com/images/logo.gif" alt="Globetrotting around the world for the passionate traveler" width="230" height="44" border="0" class="logo" />
							</a>
						</td>

						<td witdh="50%" nowrap="nowrap"><form action="http://www.globetrotting.com/search">
							<table id="utility">
								<tr valign="middle">
									<td nowrap="nowrap">
										<a href="http://www.globetrotting.com/about">About</a> | 
										<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
										<a href="http://www.globetrotting.com/press">Press Room</a>
										<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
									</td>
									<td nowrap="nowrap"><input name="searchFor" type="text" size="25"/></td>
									<td nowrap="nowrap"><input type="submit" name="Submit" value="Search"/></td>
								</tr>
							</table>
						</form></td>
					</tr>
					<tr id="stripe">
						<td colspan="2">
							<a href="http://www.globetrotting.com">
								<img src="http://www.globetrotting.com/images/logo2.gif" alt="Globetrotting" width="78" height="4" border="0" class="logo" />
							<a>
						</td>
					</tr>
					<tr bgcolor="#FFFFFF">
						<td colspan="2">
							<a href="http://www.globetrotting.com">
								<img src="http:www.globetrotting.com/images/logo2.gif" alt="Globetrotting" width="83" height="7" border="0" class="logo" />
							</a>
						</td>
					</tr>
				</table>
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="83" nowrap="nowrap" bgcolor="#FFFFFF">
							<a href="http://www.globetrotting.com">
								<img src="http://www.globetrotting.com/images/logo4.gif" width="83" height="23" border="0" class="logo" />
							</a>
						</td>
					</tr>
				</table>

				<div id="wrapper_jordan">
					<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td><div id="special-feature">
								<div id="crumb"><a href="http://www.globetrotting.com/">Home</a> &gt; <a href="http://www.globetrotting.com/jordan"><xsl:value-of select="channel/globetrotting:show/globetrotting:category"/></a></div>
								<h3><em><xsl:value-of select="channel/globetrotting:show/globetrotting:title"/></em> Airtimes</h3>

								<h5>Updated September 1, 2015</h5>
								<ul>
									<li>Visit the <a href=http://www.pbs.org/stationfinder/>PBS Station Finder</a> if your city is not listed, call your local station.</li>
								</ul>

								<table width="620" border="0" cellpadding="0" cellspacing="0" class="Airtimes">
									<tr>
										<th width="180" class="top">City, State</th>
										<th width="180" class="top">Station, Website</th>
										<th width="75" class="top">Air Date</th>
										<th width="95" class="top">Time</th>
									</tr>

									<xsl:apply-templates select="/channel/states/group"/>
								</table>

								<p><xsl:text disable-output-escaping="yes"><&amp;nbsp;</xsl:text></p>
							</div></td>
						</tr>
					</table>

					<div id="footer">
						<a href="http://www.globetrotting.com/about/contact">Contact Us</a><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text> |<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text> <a href="http://www.globetrotting.com/about/faq">Frequently Asked Questions</a><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="group">
		<tr>
			<th width="180"><xsl:value-of select="@name"/></th>
			<th width="180"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></th>
			<th width="75"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></th>
			<th width="95"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></th>
		</tr>

		<xsl:apply-templates select="item"/>

		<tr>
			<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
			<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
			<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
			<td><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></td>
		</tr>
	</xsl:template>


	<xsl:template match="item">
		<xsl:element name="tr">
			<xsl:if test="position() mod 2 = 0"><xsl:attribute name="class">grey</xsl:attribute></xsl:if>
			<td><xsl:value-of select="area"/></td>
			<td><xsl:apply-templates select="station"/></td>
			<td><xsl:value-of select="date"/></td>
			<td><xsl:value-of select="time"/></td>
		</xsl:element>
	</xsl:template>

	<xsl:template match="station">
		<a><xsl:attribute name="href"><xsl:value-of select="link"/></xsl:attribute><xsl:value-of select="name"/></a>
		<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
	</xsl:template>

</xsl:stylesheet>

