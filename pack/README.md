Pack version history:
   # v1.0 - 12 Aug 25 - Author: brenet@juniper.net - Initial release
   # v1.1 - 10 Oct 25 - Author: brenet@juniper.net - automatic detection of IRB based peering via the existence of vlan.ipv4_address

For any IRB based Generic System BGP peering, there is a VGA (Virtual Gateway Address i.e. shared IP) created. 
This configlet automatically changes the next-hop for the routes advertised to the Generic System so that it is the VGA instead of the original IRB. 

This next-hop rewrite greatly improves the design:
   - Today, a remote device (let’s say a FW) receives the same route from the 2 Leafs so if it does ECMP its routing table keeps the 2 routes. With the VGA, there are 2 peers but one route so the FW routing table is half the size
   - Today, if Leaf 1 dies, the FW needs to work on its routing table to clear the route coming from Leaf1. With the VGA, there is no clearing needed, the routing table stays the same (i.e. no reconvergence)
   - Today if FW picks up the route sent by Leaf1 but sends the packet via Leaf2 (because of the LAG), the traffic goes Leaf2/Spine/Leaf1 where it is routed to the destination. With the VGA, whoever (leaf1 or leaf2) receives the traffic, routes it, there is no more this extra traffic on the Fabric to go between Leafs. So we decrease the overall Fabric utilization as well as we optimize the routing (no extra hop anymore).
   - Today FW needs to be configured with ECMP to be able to spread the load across the 2 next-hops. With the VGA, there is no need to configure ECMP on the FW as there is only one next-hop (the load balancing is at the LAG level)
   - Finally, imagine a NSX Edge that can move across 2 ESXis (one connected to Leaf1/2, one connected to Leaf3/4), today each Leaf (1/2/3/4) needs to peer with the FW. With the VGA we could imagine peering only with Leaf1/2 and when the NSX Edge moved towards Leaf3/4, these Leaf can still route the traffic as they handle the VGA. So that limits the number of BGP peerings needed and again it avoids the extra hops (today if NSX choses Leaf1 as the next hop but it is has moved to the ESXi connected physically to Leaf3/4 then there is the same extra hop process described above)
