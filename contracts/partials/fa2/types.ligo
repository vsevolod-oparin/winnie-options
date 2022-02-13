// Types

type token_id is nat

type transfer is [@layout:comb] record [
  from_         : address;
  to_           : address;
  token_id      : token_id;
  amount        : nat;
]

type balance_of_request is [@layout:comb] record [
  owner         : address;
  token_id      : token_id;  
]

type balance_of_response is [@layout:comb] record [
  request       : balance_of_request;
  balance       : nat;
]

type balance_of_param is [@layout:comb] record [
  requests      : list(balance_of_request);
  callback      : contract(list(balance_of_response));
]

type total_supply_response is [@layout:comb] record [
  token_id      : token_id;
  total_supply  : nat;
]

type total_supply_param is [@layout:comb] record [
  token_ids     : list(token_id);
  callback      : contract(list(total_supply_response));
]

type token_metadata is [@layout:comb] record [
  token_id      : token_id;
  symbol        : string;
  name          : string;
  decimals      : nat;
  extras        : map(string, string);
]

type token_metadata_param is [@layout:comb] record [
  token_ids     : list(token_id);
  callback      : contract(list(token_metadata));
]

type operator_tokens is [@layout:comb]
  | All_tokens
  | Some_tokens of set(token_id)

type operator_param is [@layout:comb] record [
  owner         : address;
  operator      : address;
  tokens        : operator_tokens;
]

type update_operator is [@layout:comb]
  | Add_operator of operator_param
  | Remove_operator of operator_param

type is_operator_response is [@layout:comb] record [
  operator      : operator_param;
  is_operator   : bool;
]

type is_operator_param is [@layout:comb] record [
  operator      : operator_param;
  callback      : contract(is_operator_response);
]

// Permission Policy Definition

type operator_transfer_policy is [@layout:comb]
  | No_transfer
  | Owner_transfer
  | Owner_or_operator_transfer

type owner_transfer_policy is [@layout:comb]
  | Owner_no_op
  | Optional_owner_hook
  | Required_owner_hook

type custom_permission_policy is [@layout:comb] record [
  tag           : string;
  config_api    : option(address);
]

type permissions_descriptor is [@layout:comb] record [
  operator      : operator_transfer_policy;
  receiver      : owner_transfer_policy;
  sender        : owner_transfer_policy;
  custom        : option(custom_permission_policy);
]

type fa2_entry_points is [@layout:comb]
  | Transfer                of list(transfer)
  | Balance_of              of balance_of_param
  | Total_supply            of total_supply_param
  | Token_metadata          of token_metadata_param
  | Permissions_descriptor  of contract(permissions_descriptor)
  | Update_operators        of list(update_operator)
  | Is_operator             of is_operator_param

type transfer_descriptor is [@layout:comb] record [
  from_         : option(address);
  to_           : option(address);
  token_id      : token_id;
  amount        : nat;
]

type transfer_descriptor_param is [@layout:comb] record [
  fa2           : address;
  batch         : list(transfer_descriptor);
  operator      : address;
]

type fa2_token_receiver is [@layout:comb]
  | Tokens_received of transfer_descriptor_param

type fa2_token_sender is [@layout:comb]
  | Tokens_sent of transfer_descriptor_param


