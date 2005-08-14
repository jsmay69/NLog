<?xml version="1.0" encoding="windows-1250" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:param name="target_name" />
    
    <xsl:include href="style.xsl" />

    <xsl:template match="*" mode="content">
        <xsl:if test="$target_name">
            <xsl:apply-templates select="//class[attribute/@name='NLog.TargetAttribute' and attribute/property[@name='Name']/@value=$target_name]" mode="details">
                <xsl:sort select="attribute[@name='NLog.TargetAttribute']/property[@name='Name']/@value" />
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="not($target_name)">
        <h1>Log Targets</h1>
        The following log targets are available. Click on the target name for full reference.
        <div class="noborder" style="width: 600px">
            <table>
                <xsl:apply-templates select="//class[attribute/@name='NLog.TargetAttribute']" mode="list">
                    <xsl:sort select="attribute[@name='NLog.TargetAttribute']/property[@name='Name']/@value" />
                </xsl:apply-templates>
            </table>
        </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="class" mode="list">
        <xsl:variable name="type_tag" select="attribute[@name='NLog.TargetAttribute']/property[@name='Name']/@value" />
        <tr>
            <td class="label"><a href="target.{$type_tag}.html"><xsl:value-of select="$type_tag" /></a></td>
            <td class="description"><xsl:apply-templates select="documentation/summary" /></td>
        </tr>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="summary">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="class" mode="details">
        <xsl:variable name="type_tag" select="attribute[@name='NLog.TargetAttribute']/property[@name='Name']/@value" />
        <h3><xsl:value-of select="$type_tag" /> Target</h3>
            <hr size="1" />
        <xsl:if test="documentation/summary">
            <h4>Summary</h4>
            <xsl:apply-templates select="documentation/summary" /><p/>
        </xsl:if>
        <h4>Configuration file usage:</h4>
        <code class="config">&lt;target name="..." type="<b><u><xsl:value-of select="$type_tag" /></u></b>"
            ... 
            /&gt;
        </code>
        <h4>Parameters (blue fields are required):</h4>
        <table cellspacing="0" cellpadding="0" class="paramtable">
            <tr>
                <th>Name</th>
                <th>Type</th>
                <th>Description</th>
            </tr>
            <xsl:apply-templates select="property" mode="parameter">
                <xsl:sort select="count(attribute[@name='NLog.Config.RequiredParameterAttribute'])" order="descending" />
                <xsl:sort select="@name" />
            </xsl:apply-templates>
            <xsl:if test="property[attribute/@name='NLog.Config.ArrayParameterAttribute']">
                <xsl:apply-templates select="property" mode="parameter2">
                    <xsl:sort select="count(attribute[@name='NLog.Config.RequiredParameterAttribute'])" order="descending" />
                    <xsl:sort select="@name" />
                </xsl:apply-templates>
            </xsl:if>
        </table>
        <xsl:if test="documentation/example">
            <h4>Example:</h4>
            <xsl:apply-templates select="documentation/example" />
        </xsl:if>
        <xsl:if test="documentation/remarks">
            <h4>Remarks:</h4>
            <xsl:apply-templates select="documentation/remarks" />
        </xsl:if>
        <hr size="1" />
        <a href="targets.html">Back to the target list.</a>
    </xsl:template>

    <xsl:template match="property[@set='false']" mode="parameter">
        <!-- ignore -->
    </xsl:template>

    <xsl:template match="property[@id='P:NLog.Target.Name']" mode="parameter">
        <!-- ignore -->
    </xsl:template>

    <xsl:template match="property[@id='P:NLog.Target.Type']" mode="parameter">
        <!-- ignore -->
    </xsl:template>

    <xsl:template match="property[@type='NLog.Layout']" mode="parameter">
        <!-- ignore -->
    </xsl:template>

    <xsl:template match="property" mode="parameter">
        <xsl:if test="@name != 'Layout' or not(../attribute[@name='NLog.TargetAttribute']/property[@name='IgnoresLayout']/@value='True')">
            <tr>
                <td class="parametername">
                    <span>
                        <xsl:if test="attribute/@name='NLog.Config.RequiredParameterAttribute'">
                            <xsl:attribute name="class">required</xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="@name" />
                    </span>
                </td>
                <td class="parametertype">
                    <nobr>
                        <xsl:call-template name="simple-type-name">
                            <xsl:with-param name="type" select="@type" />
                        </xsl:call-template>
                        <xsl:if test="attribute/@name='NLog.Config.AcceptsLayoutAttribute'">
                            &#160;<a href="layoutrenderers.html"><span class="acceptslayout" title="This parameter accepts layout specification. Click here to learn more about layouts.">${}</span></a>
                        </xsl:if>
                    </nobr>
                </td>
                <td class="parametervalue">
                    <xsl:apply-templates select="documentation/summary" /><br/>
                    <xsl:if test="attribute[@name='System.ComponentModel.DefaultValueAttribute']">
                        Default value is: <code><xsl:value-of select="attribute[@name='System.ComponentModel.DefaultValueAttribute']/property[@name='Value']/@value" /></code>.
                    </xsl:if>
                    <xsl:if test="documentation/remarks">
                        <xsl:apply-templates select="documentation/remarks" />
                    </xsl:if>
                    <xsl:if test="documentation/example">
                        <h4>Example</h4>
                        <p><xsl:apply-templates select="documentation/example" /></p>
                    </xsl:if>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template match="property[attribute/@name='NLog.Config.ArrayParameterAttribute']" mode="parameter2">
        <xsl:variable name="itemname" select="attribute[@name='NLog.Config.ArrayParameterAttribute']/property[@name='ElementName']/@value" />
        <xsl:variable name="itemtype" select="attribute[@name='NLog.Config.ArrayParameterAttribute']/property[@name='ItemType']/@value" />
        <tr>
            <td valign="top" class="parametername" rowspan="2">
                <xsl:value-of select="@name" />
            </td>
            <td class="parametertype" colspan="2">
                Collection of 
                <xsl:call-template name="simple-type-name">
                    <xsl:with-param name="type"><xsl:value-of select="$itemtype" /></xsl:with-param>
                </xsl:call-template>. Each element is represented as &lt;<xsl:value-of select="$itemname" />/&gt;
            </td>
        </tr>
        <tr>
            <td class="parametervalue" colspan="2">
                <table class="subparamtable" cellspacing="0" cellpadding="0" width="100%">
                    <tr>
                        <th>Name</th>
                        <th>Type</th>
                        <th>Description</th>
                    </tr>
                    <xsl:apply-templates select="//class[@id=concat('T:',$itemtype)]/property" mode="parameter" />
                </table>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="property" mode="parameter2">
    </xsl:template>

    <xsl:template match="c">
        <code><xsl:apply-templates /></code>
    </xsl:template>

    <xsl:template match="code[@escaped='true']">
        <code><pre class="xml-example"><xsl:apply-templates mode="xml-example" /></pre></code>
    </xsl:template>

    <xsl:template match="code">
        <code><pre class="example"><xsl:apply-templates /></pre></code>
    </xsl:template>

    <xsl:template match="see">
        <code><xsl:value-of select="@cref" /></code>
    </xsl:template>
</xsl:stylesheet>