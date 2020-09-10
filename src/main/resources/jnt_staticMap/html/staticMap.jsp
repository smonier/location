<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>

<link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css"
      integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A=="
      crossorigin=""/>
<script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"
        integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA=="
        crossorigin=""></script>

<c:set var="bindedComponent" value="${ui:getBindedComponent(currentNode, renderContext, 'j:bindedComponent')}"/>
<c:if test="${not empty bindedComponent && jcr:isNodeType(bindedComponent, 'jmix:geotagged,jmix:locationAware,jnt:location')}">
    <c:set var="props" value="${currentNode.propertiesAsString}"/>
    <c:set var="targetProps" value="${bindedComponent.propertiesAsString}"/>
    <c:if test="${not empty props['jcr:title']}">
        <h3>${fn:escapeXml(props['jcr:title'])}</h3>
    </c:if>


        <c:if test="${not empty props['j:zoom'] && props['j:zoom'] != 'auto'}">
            <c:set var="zoom" value="${props['j:zoom']}"/>
        </c:if>
        <c:set var="size" value="${props['j:width']}x${props['j:height']}"/>
        <c:if test="${not empty props['j:mapType']}">
            <c:set var="maptype" value="${props['j:mapType']}"/>
        </c:if>
        <c:set var="language" value="${currentResource.locale.language}"/>
        <c:set var="displayName" value="${targetProps['displayName']}"/>
        <c:choose>
            <c:when test="${not empty targetProps['j:latitude'] && not empty targetProps['j:longitude']}">
                <c:set var="location" value="${targetProps['j:latitude']},${targetProps['j:longitude']}"/>
            </c:when>
            <c:otherwise>
                <c:set var="location" value="${targetProps['j:street']}"/>
                <c:set var="location"
                       value="${location}${not empty location ? ',' : ''}${targetProps['j:zipCode']}"/>
                <c:set var="location" value="${location}${not empty location ? ',' : ''}${targetProps['j:town']}"/>
                <jcr:nodePropertyRenderer name="j:country" node="${bindedComponent}" renderer="country"
                                          var="country"/>
                <c:set var="location" value="${location}${not empty location ? ',' : ''}${country.displayName}"/>
            </c:otherwise>
        </c:choose>

        <c:if test="${not empty locationMapKey}">
            <c:set var="key" value="${locationMapKey}"/>
        </c:if>

    <style>
        #mapid {
            height: ${props['j:height']}px;
            /*  width:
        ${props['j:width']} px;*/
        }

        #mapid img {
            max-width: none;
            min-width: 0px;
            height: auto;
        }
    </style>

    <div id="mapid" class="mt-3"></div>

    <script type="text/javascript">
        console.log("${targetProps['j:country']}");
        var mymap = L.map('mapid').setView([${location}], ${props['j:zoom']});
        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
            attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery &copy; <a href="https://www.mapbox.com/">Mapbox</a>',
            maxZoom: 20,
            id: 'mapbox/${props['j:mapType']}',
            tileSize: 512,
            zoomOffset: -1,
            accessToken: '${locationMapBoxToken}'
        }).addTo(mymap);

        var marker = L.marker([${location}]).addTo(mymap);
        marker.bindPopup("${displayName}").openPopup();

    </script>

</c:if>
