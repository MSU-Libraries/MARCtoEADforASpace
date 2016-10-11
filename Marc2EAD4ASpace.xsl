<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
    <xsl:import href="MARC21slimUtils.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <?filetitle?>
        <ead>
            <eadheader>
                <eadid/>
                <filedesc>
                    <titlestmt>
                        <titleproper>
                            <xsl:text>Finding Aid for the </xsl:text>
                            <!-- This will pick up $c in the 245, something I've left out in the unittitle field, but wanted to capture somewhere -->
                            <xsl:for-each select="//marc:record/marc:datafield[@tag=245]">
                                <xsl:value-of
                                    select="replace(normalize-space(//marc:record/marc:datafield[@tag=245]),'\p{P}$','')"
                                />
                            </xsl:for-each>
                        </titleproper>
                        <author>Finding aid prepared by MarcEdit.</author>
                    </titlestmt>
                </filedesc>
                <profiledesc>
                    <language>English</language>
                    <descrules>
                    <xsl:choose>
                        <xsl:when test="//marc:record/marc:datafield[@tag=040]/marc:subfield[@code='e']='rda'">
                            <xsl:text>RDA</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>Anglo-American Cataloguing Rules</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    </descrules>
                </profiledesc>
            </eadheader>
            <xsl:apply-templates/>
        </ead>
    </xsl:template>

    <xsl:template match="marc:record">
        <archdesc level="collection">
            <did>
                <xsl:for-each select="marc:datafield[@tag=100]">
                    <origination>
                        <persname role="creator">
                            <xsl:value-of select="."/>
                        </persname>
                    </origination>
                </xsl:for-each>
                <!--Added 700 field for contributors-->
                <xsl:for-each select="marc:datafield[@tag=700]">
                    <origination>
                        <persname role="creator">
                            <xsl:value-of select="."/>
                        </persname>
                    </origination>
                </xsl:for-each>
                <!-- Added 110 for contributors-->
                <xsl:for-each select="marc:datafield[@tag=110]">
                    <origination>
                        <corpname role="creator">
                            <xsl:value-of select="."/>
                        </corpname>
                    </origination>
                </xsl:for-each>
                <!-- Added 710 for contributors-->
                <xsl:for-each select="marc:datafield[@tag=710]">
                    <origination>
                        <corpname role="creator">
                            <xsl:value-of select="."/>
                        </corpname>
                    </origination>
                </xsl:for-each>
                <xsl:for-each select="marc:datafield[@tag=245]">
                    <unittitle type="collection">
                        <xsl:if test="marc:subfield[@code='a']">
                        <xsl:value-of
                            select="replace(normalize-space(//marc:record/marc:datafield[@tag=245]/marc:subfield[@code='a']),'\p{P}$','')"
                        />
                        </xsl:if>
                        <xsl:if test="marc:subfield[@code='b']">
                            <xsl:text>: </xsl:text>
                            <xsl:value-of
                                select="replace(normalize-space(//marc:record/marc:datafield[@tag=245]/marc:subfield[@code='b']),'\p{P}$','')"
                            />
                        </xsl:if>
                    </unittitle> 
                </xsl:for-each>
              
                    <!-- Date field - may need to be edited depending on your institutional practice 
                    TRY TO DO an IF test for each field and otherwise option for records without dates-->
                    <!--
                    <xsl:if test="marc:subfield[@code='f']!=''">
                        <unitdate type="inclusive">
                            <xsl:value-of select="replace(marc:subfield[@code='f'],'\p{P}$','')"/>
                        </unitdate>
                    </xsl:if>-->

                <xsl:choose>
                    <!--Added 260-->
                    <xsl:when test="marc:datafield[@tag=260]">
                        <unitdate type="inclusive">
                            <xsl:value-of
                                select="replace(//marc:record/marc:datafield[@tag=260]/marc:subfield[@code='c'],'[\[\]&lt;&gt;\.]+','')"
                            />
                        </unitdate>
                    </xsl:when>
                    <!--Added 264-->
                    <xsl:when test="marc:datafield[@tag=264]">
                        <unitdate type="inclusive">
                            <xsl:value-of
                                select="replace(//marc:record/marc:datafield[@tag=264]/marc:subfield[@code='c'],'[\[\]&lt;&gt;\.]+','')"
                            />
                        </unitdate>
                    </xsl:when>
                    <!-- ASpace required date field, so created an alternative if the MARC record had no date included in a date field -->
                    <xsl:otherwise>
                        <unitdate type="inclusive">Check date</unitdate>
                    </xsl:otherwise>
                </xsl:choose>
                
                <xsl:for-each select="marc:datafield[@tag=245]/marc:subfield[@code='g']">
                    <unitdate type="bulk">
                        <xsl:value-of
                            select="replace(.,'[\[\]&lt;&gt;\.]+','')"
                        />
                    </unitdate>
                </xsl:for-each>

                <!--Added 099-->
                <xsl:for-each select="//marc:record/marc:datafield[@tag=099]">
                    <unitid>
                        <xsl:value-of
                            select="marc:subfield[@code='a']"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of
                            select="marc:subfield[@code='f']" />
                    </unitid>
                </xsl:for-each>
                <!-- Took out 090
                <xsl:if test="//marc:record/marc:datafield[@tag=090]">
                    <unitid>
                        <xsl:value-of
                            select="//marc:record/marc:datafield[@tag=090]/marc:subfield[@code='a']/."/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of
                            select="//marc:record/marc:datafield[@tag=090]/marc:subfield[@code='f']/."
                        />
                    </unitid>
                </xsl:if>
                -->
                <xsl:for-each select="marc:datafield[@tag=300]">
                    <physdesc altrender="whole">
                        
                        <!--Using the 300$a to get linear feet count for collections with $f of box or boxes.  Otherwise it will spit out .1 linear feet for someone to back and check.-->
                       <xsl:choose>
                            <xsl:when test="marc:subfield[@code='f']!='boxes|box|box ;|boxes ;|linear feet.'">
                                <extent altrender="materialtype spaceoccupied">
                                    <xsl:value-of select="replace(replace(marc:subfield[@code='a'][1],'\(.+\)',''),'\D','')"/>
                                    <xsl:text> Linear Feet</xsl:text>
                                </extent>
                                </xsl:when>
                           <xsl:otherwise>
                               <extent altrender="materialtype spaceoccupied">
                                   <xsl:text>.1 Linear Feet</xsl:text>
                               </extent>
                           </xsl:otherwise>
                        </xsl:choose>
                        
                        <!-- I opted to dump the entire 300 field so I could see if anything was missed.  This means spacing is a little wonky, but the data is there -->
                        <extent altrender="carrier">
                            <xsl:value-of select="."/>
                        </extent>

                        <xsl:for-each select="marc:subfield[@code='b']">
                            <physfacet>
                                <xsl:value-of select="marc:subfield[@code='b']"/>
                            </physfacet>
                        </xsl:for-each>

                        <xsl:for-each select="marc:subfield[@code='c']">
                            <dimensions>
                                <xsl:value-of select="marc:subfield[@code='c']"/>
                            </dimensions>
                        </xsl:for-each>
                    </physdesc>
                </xsl:for-each>
                
                <!-- unitdate listed above on line 86 -->
                <!--These maps are based on the EAD to MARC Crosswalk, and Terry's work-->
                <xsl:for-each select="marc:datafield[@tag=254]">
                    <materialspec>
                        <xsl:value-of select="."/>
                    </materialspec>
                </xsl:for-each>

                <xsl:for-each select="marc:datafield[@tag=852]">
                    <physloc>
                        <xsl:value-of select="marc:subfield[@code='z']"/>
                    </physloc>
                </xsl:for-each>
                <xsl:choose>
                    <xsl:when test="marc:datafield[@tag=546]">
                        <langmaterial> Material is in <xsl:text> </xsl:text>
                            <language>
                                <xsl:value-of select="marc:datafield[@tag=546]"/>
                            </language>
                            <xsl:text>.</xsl:text>
                        </langmaterial>
                    </xsl:when>
                    <!-- Most of our material is in English, so I opted to add an otherwise clause for items where language isn't mentioned -->
                    <xsl:otherwise>
                        <langmaterial>Material is in <language>English</language> unless otherwise
                            noted.</langmaterial>
                    </xsl:otherwise>
                </xsl:choose>
            </did>

            <xsl:choose>
                <xsl:when test="marc:datafield[@tag=506]">
                    <accessrestrict>
                        <p>
                            <xsl:value-of select="marc:datafield[@tag=506]"/>
                        </p>
                    </accessrestrict>
                </xsl:when>
                <xsl:otherwise>
                    <accessrestrict>
                        <p> The collection is open for research.</p>
                    </accessrestrict>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="marc:datafield[@tag=540]">
                    <userestrict>
                        <p>
                            <xsl:value-of select="marc:datafield[@tag=540]"/>
                        </p>
                    </userestrict>
                </xsl:when>
                <xsl:otherwise>
                    <userestrict>
                        <p> Copyright is retained by the author of the items in this collection, or
                            their descendants, as stipulated by United States copyright law.</p>
                    </userestrict>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="marc:datafield[@tag=524]">
                    <prefercite>
                        <p>
                            <xsl:value-of select="marc:datafield[@tag=524]"/>
                        </p>
                    </prefercite>
                </xsl:when>
                <xsl:otherwise>
                    <prefercite>
                        <p>Item, Folder number and/or title, Box number, Collection title, MSS number,
                            Special Collections, MSU Libraries, Michigan State University, East
                            Lansing, MI</p>
                    </prefercite>
                </xsl:otherwise>
            </xsl:choose>
           
            <xsl:choose>
            <xsl:when test="marc:datafield[@tag=541]">
                <acqinfo>
                    <p>
                        <xsl:value-of select="marc:datafield[@tag=541]"/>
                    </p>
                </acqinfo>
            </xsl:when>
            <xsl:otherwise>
                <acqinfo>
                    <p>
                        Accession information unknown.
                    </p>
                </acqinfo>
            </xsl:otherwise>
            </xsl:choose>

            <xsl:for-each select="marc:datafield[@tag=561]">
                <custodhist>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </custodhist>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=584]">
                <accruals>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </accruals>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=583]">
                <processinfo>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </processinfo>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=545]">
                <bioghist>
                    <!--Use heading Historical Note for corporate history-->
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </bioghist>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=520]">
                <scopecontent>
                    <p>
                    <xsl:value-of select="marc:subfield[@code='a']"/>
                    </p>
                </scopecontent>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=351]">
                <arrangement>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </arrangement>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=504]">
                <bibref>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </bibref>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=538]">
                <phystech>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </phystech>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=535]">
                <originalsloc>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </originalsloc>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=500]">
                <odd>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            <!--Added 590 for local notes-->
            <xsl:for-each select="marc:datafield[@tag=590]">
                <odd>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            <!--The notes below I added based on what fields were used in the records.  These are not typical archives fields, so I used notes with headers.  The headers are the title of the field in MARC. -->
                       <xsl:for-each select="marc:datafield[@tag=130]">
                <odd>
                    <head>
                        <xsl:text>Uniform Title</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=240]">
                <odd>
                    <head>
                        <xsl:text>Uniform Title</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=246]">
                <odd>
                    <head>
                        <xsl:text>Varying Form of Title</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=321]">
                <odd>
                    <head>
                        <xsl:text>Former Publication Frequency</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            <xsl:for-each select="marc:datafield[@tag=440]">
                <odd>
                    <head>
                        <xsl:text>Series</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=440]">
                <odd>
                    <head>
                        <xsl:text>Series</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=502]">
                <odd>
                    <head>
                        <xsl:text>Dissertation Note</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=505]">
                <odd>
                    <head>
                        <xsl:text>Table of Contents</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
           <xsl:for-each select="marc:datafield[@tag=510]">
                <odd>
                    <head>
                        <xsl:text>Citation/Reference</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=511]">
                <odd>
                    <head>
                        <xsl:text>Participant or Performer Note</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=533]">
                <odd>
                    <head>
                        <xsl:text>Reproduction Note</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=580]">
                <odd>
                    <head>
                        <xsl:text>Linking Entry Complexity Note</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=711]">
                <odd>
                    <head>
                        <xsl:text>Meeting Name</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=730]">
                <odd>
                    <head>
                        <xsl:text>Added Entry–Uniform Title</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=740]">
                <odd>
                    <head>
                        <xsl:text>Uncontrolled Related/Analytical Title</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=773]">
                <odd>
                    <head>
                        <xsl:text>Host Item</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=776]">
                <odd>
                    <head>
                        <xsl:text>Additional Physical Form</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=800]">
                <odd>
                    <head>
                        <xsl:text>Series Added Entry</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=866]">
                <odd>
                    <head>
                        <xsl:text>Holdings</xsl:text>
                    </head>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </odd>
            </xsl:for-each>
            
            <!--I opted for these to come after, since they aren't used much in our data, and thus, are less important to us.-->
            <xsl:for-each select="marc:datafield[@tag=530]">
                <altformavail encodinganalog="530" id="a9">
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </altformavail>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=544]">
                <separatedmaterial>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </separatedmaterial>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=581]">
                <bibliography>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </bibliography>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=555]">
                <otherfindaid>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </otherfindaid>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=544]">
                <relatedmaterial>
                    <p>
                        <xsl:value-of select="."/>
                    </p>
                </relatedmaterial>
            </xsl:for-each>
            
            <!--Subject headings-->
            <xsl:for-each select="marc:datafield[@tag=600]">
                <controlaccess>
                    <persname source="naf" role="subject" encodinganalog="600">
                        <xsl:for-each select="marc:subfield">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text> -- </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </persname>
                </controlaccess>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=610]">
                <controlaccess>
                    <corpname source="naf" role="subject" encodinganalog="610">
                        <xsl:for-each select="marc:subfield">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text> -- </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </corpname>
                </controlaccess>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=651]">
                <controlaccess>
                    <geogname source="lcsh" role="subject" encodinganalog="651">
                        <xsl:for-each select="marc:subfield">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text> -- </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </geogname>
                </controlaccess>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=650]">
                <controlaccess>
                    <subject source="lcsh" encodinganalog="650">
                        <xsl:for-each select="marc:subfield">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text> -- </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </subject>
                </controlaccess>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=655]">
                <controlaccess>
                    <genreform source="lcsh" encodinganalog="655">
                        <xsl:for-each select="marc:subfield">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text> -- </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </genreform>
                </controlaccess>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=653]">
                <controlaccess>
                    <genreform source="lcsh" encodinganalog="655">
                        <xsl:for-each select="marc:subfield">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text> -- </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </genreform>
                </controlaccess>
            </xsl:for-each>
            
            <xsl:for-each select="marc:datafield[@tag=656]">
                <controlaccess>
                    <occupation source="lcsh" encodinganalog="656">
                        <xsl:for-each select="marc:subfield">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text> -- </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </occupation>
                </controlaccess>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=657]">
                <controlaccess>
                    <function source="aat" encodinganalog="657">
                        <xsl:for-each select="marc:subfield">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text> -- </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </function>
                </controlaccess>
            </xsl:for-each>

            <xsl:for-each select="marc:datafield[@tag=630]">
                <controlaccess>
                    <title encodinganalog="630" source="naf">
                        <xsl:for-each select="marc:subfield">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">
                                <xsl:text> -- </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </title>
                </controlaccess>
            </xsl:for-each>

            <!-- Insert container listing here
            <dsc type="combined"> 
                ADD CONTAINER LISTING
            </dsc>-->
        </archdesc>
    </xsl:template>
</xsl:stylesheet>
<!--http://creativecommons.org/licenses/zero/1.0/
    Creative Commons 1.0 Universal
    The person who associated a work with this document has dedicated this work to the 
    Commons by waiving all of his or her rights to the work under copyright law and all 
    related or neighboring legal rights he or she had in the work, to the extent allowable by law. 
-->
