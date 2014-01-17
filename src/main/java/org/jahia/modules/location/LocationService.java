/**
 * This file is part of Jahia, next-generation open source CMS:
 * Jahia's next-generation, open source CMS stems from a widely acknowledged vision
 * of enterprise application convergence - web, search, document, social and portal -
 * unified by the simplicity of web content management.
 *
 * For more information, please visit http://www.jahia.com.
 *
 * Copyright (C) 2002-2014 Jahia Solutions Group SA. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 *
 * As a special exception to the terms and conditions of version 2.0 of
 * the GPL (or any later version), you may redistribute this Program in connection
 * with Free/Libre and Open Source Software ("FLOSS") applications as described
 * in Jahia's FLOSS exception. You should have received a copy of the text
 * describing the FLOSS exception, and it is also available here:
 * http://www.jahia.com/license
 *
 * Commercial and Supported Versions of the program (dual licensing):
 * alternatively, commercial and supported versions of the program may be used
 * in accordance with the terms and conditions contained in a separate
 * written agreement between you and Jahia Solutions Group SA.
 *
 * If you are unsure which license is appropriate for your use,
 * please contact the sales department at sales@jahia.com.
 */

package org.jahia.modules.location;

import com.google.code.geocoder.Geocoder;
import com.google.code.geocoder.GeocoderRequestBuilder;
import com.google.code.geocoder.model.GeocodeResponse;
import com.google.code.geocoder.model.GeocoderRequest;
import com.google.code.geocoder.model.GeocoderResult;
import org.drools.core.spi.KnowledgeHelper;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.rules.AddedNodeFact;

import javax.jcr.RepositoryException;
import java.util.List;

public class LocationService {

    public void geocodeLocation(AddedNodeFact node, KnowledgeHelper drools) throws RepositoryException {
        final Geocoder geocoder = new Geocoder();
        JCRNodeWrapper nodeWrapper = node.getNode();

        StringBuffer address = new StringBuffer();
        address.append(nodeWrapper.getProperty("j:street").getString());
        if (nodeWrapper.hasProperty("j:zipCode")) {
            address.append(" ").append(nodeWrapper.getProperty("j:zipCode").getString());
        }
        if (nodeWrapper.hasProperty("j:town")) {
            address.append(" ").append(nodeWrapper.getProperty("j:town").getString());
        }
        if (nodeWrapper.hasProperty("j:country")) {
            address.append(" ").append(nodeWrapper.getProperty("j:country").getString());
        }
        if (!nodeWrapper.isNodeType("jnt:location") && !nodeWrapper.isNodeType("jmix:geotagged")) {
            nodeWrapper.addMixin("jmix:geotagged");
        }
        GeocoderRequest geocoderRequest = new GeocoderRequestBuilder().setAddress(address.toString()).getGeocoderRequest();
        GeocodeResponse geocoderResponse = geocoder.geocode(geocoderRequest);
        List<GeocoderResult> results = geocoderResponse.getResults();
        if (results.size() > 0) {
            nodeWrapper.setProperty("j:latitude", results.get(0).getGeometry().getLocation().getLat().toString());
            nodeWrapper.setProperty("j:longitude", results.get(0).getGeometry().getLocation().getLng().toString());
        }
    }
}
