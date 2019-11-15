package connect.api.impl;


class UsageApiImpl extends Base implements IUsageApi {
    private static inline var USAGE_FILES_PATH = 'usage/files';
    private static inline var USAGE_PRODUCTS_PATH = 'usage/products';
    private static inline var USAGE_RECORDS_PATH = 'usage/records';


    public function new() {}


    public function listUsageFiles(filters: QueryParams): Array<Dynamic> {
        return Env.getApiClient().get(USAGE_FILES_PATH, null, null, filters);
    }


    public function createUsageFile(body: String): Dynamic {
        return Env.getApiClient().post(USAGE_FILES_PATH, null, null, body);
    }


    public function getUsageFile(id: String): Dynamic {
        return Env.getApiClient().get(USAGE_FILES_PATH, id);
    }


    public function updateUsageFile(id: String, body: String): Dynamic {
        return Env.getApiClient().put(USAGE_FILES_PATH, id, body);
    }


    public function deleteUsageFile(id: String): Void {
        Env.getApiClient().post(USAGE_FILES_PATH, id, 'delete');
    }


    public function uploadUsageFile(id: String, file: Blob): Dynamic {
        return Env.getApiClient().postFile(
            USAGE_FILES_PATH,
            id,
            'upload',
            'usage_file',
            'usage_file.xlsx',
            file
        );
    }


    public function submitUsageFileAction(id: String): Dynamic {
        return Env.getApiClient().post(USAGE_FILES_PATH, id, 'submit');
    }


    public function acceptUsageFileAction(id: String, note: String): Dynamic {
        return Env.getApiClient().post(USAGE_FILES_PATH, id, 'accept',
            haxe.Json.stringify({acceptance_note: note}));
    }


    public function rejectUsageFileAction(id: String, note: String): Dynamic {
        return Env.getApiClient().post(USAGE_FILES_PATH, id, 'reject',
            haxe.Json.stringify({rejection_note: note}));
    }


    public function closeUsageFileAction(id: String): Dynamic {
        return Env.getApiClient().post(USAGE_FILES_PATH, id, 'close');
    }


    public function getProductSpecificUsageFileTemplate(productId: String): Dynamic {
        return Env.getApiClient().get(USAGE_PRODUCTS_PATH, productId, 'template');
    }


    public function uploadReconciliationFileFromProvider(id: String, file: Blob): Dynamic {
        return Env.getApiClient().postFile(
            USAGE_FILES_PATH,
            id,
            'reconciliation',
            'reconciliation_file',
            'reconciliation_file.xlsx',
            file
        );
    }


    public function reprocessProcessedFile(id: String): Dynamic {
        return Env.getApiClient().post(USAGE_FILES_PATH, id, 'reprocess');
    }


    public function listUsageRecords(filters: QueryParams): Array<Dynamic> {
        return Env.getApiClient().get(USAGE_RECORDS_PATH, null, null, filters);
    }


    public function getUsageRecord(id: String): Dynamic {
        return Env.getApiClient().get(USAGE_RECORDS_PATH, id);
    }


    public function updateUsageRecord(id: String, record: String): Dynamic {
        return Env.getApiClient().put(USAGE_RECORDS_PATH, id, record);
    }


    public function closeUsageRecord(id: String, record: String): Dynamic {
        return Env.getApiClient().post(USAGE_RECORDS_PATH, id, 'close', record);
    }
}
