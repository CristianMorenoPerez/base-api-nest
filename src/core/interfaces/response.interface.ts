
export interface ResponseData<T> {
    data: T
}


export interface ResponseDataPagination<T> extends ResponseData<T> {
    meta: Imeta | any
}


export interface Imeta {
    total: number,
    page: number,
    lastPage: number
}
