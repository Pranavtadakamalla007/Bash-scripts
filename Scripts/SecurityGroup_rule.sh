#!/bin/bash

SECURITY_GROUP_ID="sg-0ba33d3dc30423d93"
echo "Using Security Group ID: $SECURITY_GROUP_ID"


IP_LIST=(
"20.37.158.0/23"
"20.37.194.0/24"
"20.39.13.0/26"
"20.41.6.0/23"
"20.41.194.0/24"
"20.42.5.0/24"
"20.42.134.0/23"
"20.42.226.0/24"
"20.45.196.64/26"
"20.91.148.128/25"
"20.125.155.0/24"
"20.166.41.0/24"
"20.189.107.0/24"
"20.195.68.0/24"
"20.204.197.192/26"
"20.233.130.0/25"
"40.74.28.0/23"
"40.80.187.0/24"
"40.82.252.0/24"
"40.119.10.0/24"
"51.104.26.0/24"
"52.150.138.0/24"
"52.228.82.0/24"
"191.235.226.0/24"
"2603:1030:a07:15::3d2/127"
"2603:1030:a07:15::3d8/125"
)

for ip_range in "${IP_LIST[@]}"; do
  echo "Adding rule for $ip_range..."
  if [[ $ip_range == *:* ]]; then
    aws ec2 authorize-security-group-ingress \
      --group-id "$SECURITY_GROUP_ID" \
      --ip-permissions "[{\"IpProtocol\":\"tcp\",\"FromPort\":22,\"ToPort\":22,\"Ipv6Ranges\":[{\"CidrIpv6\":\"$ip_range\",\"Description\":\"Azure DevOps IPv6\"}]}]" \
    || echo "Rule already exists for $ip_range"
  else
    aws ec2 authorize-security-group-ingress \
      --group-id "$SECURITY_GROUP_ID" \
      --ip-permissions "[{\"IpProtocol\":\"tcp\",\"FromPort\":22,\"ToPort\":22,\"IpRanges\":[{\"CidrIp\":\"$ip_range\",\"Description\":\"Azure DevOps IPv4\"}]}]" \
    || echo "Rule already exists for $ip_range"
  fi
done
