<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>

<template:addResources type="javascript" resources="reverseGeocoding.js"/>
<template:addResources type="javascript" resources="weatherForecast.js"/>
<template:addResources type="css" resources="weatherForecast.css"/>
<jcr:nodeProperty node="${currentNode}" name="units" var="units"/>

<c:set var="bindedComponent" value="${ui:getBindedComponent(currentNode, renderContext, 'j:bindedComponent')}"/>
<c:if test="${not empty bindedComponent && jcr:isNodeType(bindedComponent, 'jmix:geotagged,jmix:locationAware,jnt:location')}">
    <c:set var="props" value="${currentNode.propertiesAsString}"/>
    <c:set var="targetProps" value="${bindedComponent.propertiesAsString}"/>
    <c:if test="${not empty props['jcr:title']}">
        <h3>${fn:escapeXml(props['jcr:title'])}</h3>
    </c:if>
    <c:set var="uuid" value="${targetProps['jcr:uuid']}"/>

    <c:set var="language" value="${currentResource.locale.language}"/>

    <c:if test="${not empty targetProps['j:latitude'] && not empty targetProps['j:longitude']}">
        <c:set var="latitude" value="${targetProps['j:latitude']}"/>
        <c:set var="longitude" value="${targetProps['j:longitude']}"/>
    </c:if>
    <c:set var="city" value="${targetProps['j:town']}"/>
    <jcr:nodePropertyRenderer name="j:country" node="${bindedComponent}" renderer="country"
                              var="country"/>
    <c:set var="countryName" value="${country.displayName}"/>
    <c:if test="${not empty locationMapKey}">
        <c:set var="key" value="${locationMapKey}"/>
    </c:if>
    <c:set var="displayName" value="${targetProps['displayName']}"/>
</c:if>

<div id="weatherCard-${uuid}" class="weatherCard-container mt-3">
    <div class="weatherCard">
        <div class="front">
            <div class="cover">
                <img id="cityPic-${uuid}" src="#"/>
            </div>
            <div class="user">
                <img id="iconow-${uuid}" src="#"/>
            </div>

            <div class="content">
                <div class="main">
                    <h2 id="timezone-${uuid}" class="name ml-3">City</h2>
                    <div class="wtime mb-1">
                        <div id="wDate-${uuid}">Date</div>
                        <div id="wTime-${uuid}" class="ml-2">Time</div>
                    </div>
                    <div id="temp-${uuid}" class="temp">Temp</div>
                    <div id="dailySummary-${uuid}" class="summaryTxt" align="center">summary</div>

                </div>
                <div class="footer">
                    <i class="fa fa-mail-forward"></i>
                </div>
            </div>
        </div> <!-- end front panel -->
        <div class="back">
            <div class="header">
                <h5 id="summary-${uuid}" class="motto">"To be or not to be, this is my awesome motto!"</h5>
            </div>
            <div class="content">
                <div class="main">
                    <h4 id="wCity1-${uuid}" class="text-center"></h4>
                    <p id="wDate1-${uuid}" class="text-center"></p>
                    <p id="wTime1-${uuid}" class="text-center"></p>


                    <div class="stats-container">
                        <div class="stats">
                            <h4 id="day-${uuid}1">235</h4>
                            <p>

                                <img id="iconow1-${uuid}" height="40px" src="#"/>

                                <br/><span id="templow1-${uuid}" class="mb-1">Temp</span> / <span id="temphigh1-${uuid}" class="mb-1">Temp</span>
                            </p>
                        </div>
                        <div class="stats">
                            <h4 id="day2-${uuid}">235</h4>
                            <p>

                                <img id="iconow2-${uuid}" height="40px" src="#"/>

                                <br/><span id="templow2-${uuid}" class="mb-1">Temp</span> / <span id="temphigh2-${uuid}" class="mb-1">Temp</span>
                            </p>
                        </div>
                        <div class="stats">
                            <h4 id="day3-${uuid}">235</h4>
                            <p>

                                <img id="iconow3-${uuid}" height="40px" src="#"/>

                                <br/><span id="templow3-${uuid}" class="mb-1">Temp</span> / <span id="temphigh3-${uuid}" class="mb-1">Temp</span>
                            </p>
                        </div>
                    </div>
                    <div class="stats-container">
                        <div class="stats">
                            <h4 id="day4-${uuid}">235</h4>
                            <p>

                                <img id="iconow4-${uuid}" height="40px" src="#"/>

                                <br/><span id="templow4-${uuid}" class="mb-1">Temp</span> / <span id="temphigh4-${uuid}" class="mb-1">Temp</span>
                            </p>
                        </div>
                        <div class="stats">
                            <h4 id="day5-${uuid}">235</h4>
                            <p>

                                <img id="iconow5-${uuid}" height="40px" src="#"/>

                                <br/><span id="templow5-${uuid}" class="mb-1">Temp</span> / <span id="temphigh5-${uuid}" class="mb-1">Temp</span>
                            </p>
                        </div>
                        <div class="stats">
                            <h4 id="day6-${uuid}">235</h4>
                            <p>

                                <img id="iconow6-${uuid}" height="40px" src="#"/>

                                <br/><span id="templow6-${uuid}" class="mb-1">Temp</span> / <span id="temphigh6-${uuid}" class="mb-1">Temp</span>
                            </p>
                        </div>
                    </div>

                </div>
            </div>
            <div class="footer">
                <div class="social-links text-center">

                </div>
            </div>
        </div> <!-- end back panel -->
    </div> <!-- end card -->
</div>
<!-- end card-container -->

<script language='javascript'>
    <c:if test="${not empty targetProps['j:latitude'] && not empty targetProps['j:longitude']}">

    weatherForecast('${latitude}', '${longitude}', '${openWeatherMapKey}', '${units}', '${locationMapKey}','${uuid}');
    </c:if>
    $().ready(function () {
        $('[rel="tooltip"]').tooltip();

    });

    function rotateCard(btn) {
        var $card = $(btn).closest('#weatherCard-${uuid}');
        console.log($card);
        if ($card.hasClass('hover')) {
            $card.removeClass('hover');
        } else {
            $card.addClass('hover');
        }
    }
</script>
