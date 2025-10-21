#  Copyright (c) Juniper Networks, Inc., 2025-2025.
#  All rights reserved.
#  SPDX-License-Identifier: MIT
# v1.0 - 12 Aug 25 - Author: brenet@juniper.net - Initial release 
# v1.1 - 10 Oct 25 - Author: brenet@juniper.net - automatic detection of IRB based peering via the existence of vlan.ipv4_address

resource "apstra_configlet" "example" {
  name = var.name
  generators = [
    {
      config_style  = "junos"
      section       = "top_level_set_delete"
      template_text = <<-EOT
        {% for peers in bgp_sessions.itervalues() %}
            {% for vlan in vlan.itervalues() %}
       	        {% if vlan.ipv4_address == peers.source_ip %}
       	            set policy-options policy-statement PL-CONFIGLET-REWRITE-NH-{{ peers.vrf_name }}-{{ peers.dest_ip}} term NH then next-hop {{ vlan.fhrp_ipv4_address }}
       	            set policy-options policy-statement PL-CONFIGLET-REWRITE-NH-{{ peers.vrf_name }}-{{ peers.dest_ip}} term NH then next policy
    	            delete routing-instances {{ peers.vrf_name }} protocols bgp group l3rtr neighbor {{ peers.dest_ip }} export ( {{ peers.route_map_out }} )
                    set routing-instances {{ peers.vrf_name }} protocols bgp group l3rtr neighbor {{ peers.dest_ip }} export PL-CONFIGLET-REWRITE-NH-{{ peers.vrf_name }}-{{ peers.dest_ip}}   
       	            set routing-instances {{ peers.vrf_name }} protocols bgp group l3rtr neighbor {{ peers.dest_ip }} export {{ peers.route_map_out }} 
                {% endif %}
            {% endfor %}
        {% endfor %}
      EOT
    },
  ]
}
