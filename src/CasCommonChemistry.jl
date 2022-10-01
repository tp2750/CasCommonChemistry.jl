module CasCommonChemistry

using HTTP, URIs
using JSON
using DataFrames

export cas, cas_search

function get_json(uri)
    reply = HTTP.get(uri, ["Accept" => "application/json"])
    body = String(reply.body)
    JSON.parse(body)
end

function cas_detail(casnr; api_url="https://commonchemistry.cas.org/api")
    uri = string(api_url,"/detail?cas_rn=",casnr)
    get_json(uri)
end


"""
    cas_search(query; api_url = "https://commonchemistry.cas.org/api", size=10, offset=0)

    Query the CAS Common Chemistry API with query string.
    Returns Dict with 2 keys:

    * "count": the number of matching records
    * "results": vector of Dics describing the first `size` results

    keyword arguments

    size: number of results to return. The API limits this to 100
    offset: number of records to skip. This is used to get records past the first 100
"""
function cas_search(query; api_url = "https://commonchemistry.cas.org/api", size=10, offset=0)
    uri = string(api_url,"/search?q=",URIs.escapeuri(query),"&size=",size,"&offset=",offset)
    get_json(uri)
end


"""
    cas(query; api_url = "https://commonchemistry.cas.org/api", fetch=10, skip = 0, pagesize = 100)

    Query the CAS Common Chemistry API with query string.
    Returns DataFrame of matching records

    From the API description: https://commonchemistry.cas.org/api-overview
    * Allows searching by CAS RN (with or without dashes), SMILES (canonical or isomeric), InChI (with or without the "InChI=" prefix), InChIKey, and name
    * Searching by name allows use of a trailing wildcard (e.g., car*)
    * All searches are case-insensitive

    A wild-card query can return a lot of entries taking a long time to fetch. So by default, only the first 10 are fetched. The total number is reported.
    Use fetch = :all to unconditionally get all.

    query : query string. Will be uri encoded
    fetch N: maximal number of recoreds to fetch. An integer of :all.
    skip N : Skip first N records
    pagesize: Default page-size in CAS API is 100. A lower value can e set. Mostly for debugging
"""
function cas(query; api_url = "https://commonchemistry.cas.org/api", fetch=10, skip = 0, pagesize = 100)
    found = cas_search(query)
    n_res = found["count"]
    fetch = fetch == :all ? n_res : fetch
    fetch_string = "$(skip+1)..$(min(fetch, n_res) + skip)" 
    @info "Found $(n_res) results from query '$query'. Fetching $fetch_string"
    ResList = Dict{String,Any}[]
    rest = min(fetch, n_res)
    size = min(pagesize, 100)
    while (rest > 0)
        @debug "Fetching page of size $size. Rest: $rest"
        fetch = min(fetch, size)
        found = cas_search(query, size=fetch, offset=skip)
        for res in found["results"]
            push!(ResList, cas_detail(res["rn"]))
        end
        skip = skip + size
        rest = rest - size
    end
    DataFrame(ResList)
end


end
