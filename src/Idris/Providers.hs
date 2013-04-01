module Idris.Providers where

import Core.TT
import Core.Evaluate
import Core.Execute
import Idris.AbsSyntax
import Idris.AbsSyntaxTree
import Idris.Error

import Debug.Trace

-- | Wrap a type provider in the type of type providers
providerTy :: FC -> PTerm -> PTerm
providerTy fc tm = PApp fc (PRef fc $ UN "Provider") [PExp 0 False tm ""]

-- | Wrap the RHS of a type provider definition
unProv :: FC -> PTerm -> PTerm
unProv fc tm = PApp fc (PRef fc $ NS (UN "unProv") ["Providers"]) [PExp 0 False tm ""]

-- | Handle an error, if the type provider returned an error. Otherwise do nothing.
providerError :: TT Name -> Idris ()
providerError tm = case unApply tm of
                     (P _ (NS (UN "unProv") ["Providers"]) _, [_, tm']) ->
                         case unApply tm' of
                           (P _ (NS (UN "Error") ["Providers"]) _, [_, err]) ->
                               do str <- execute err
                                  case (unApply str) of
                                    (Constant (Str msg), []) ->
                                        ierror . ProviderError $ msg
                                    (P _ (UN "prim__IO") _, [_, (Constant (Str msg))]) ->
                                        ierror . ProviderError $ msg
                                    _ -> fail "Error in type provider."
                           _ -> return ()
                     _ -> return ()
